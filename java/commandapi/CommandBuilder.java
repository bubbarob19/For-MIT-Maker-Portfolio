package net.abundantmc.abundantlibrary.spigotlibrary.command;

import net.abundantmc.abundantlibrary.spigotlibrary.utilities.ChatUtils;
import net.kyori.adventure.text.Component;
import org.bukkit.Bukkit;
import org.bukkit.command.Command;
import org.bukkit.command.CommandMap;
import org.bukkit.command.CommandSender;
import org.bukkit.command.ConsoleCommandSender;
import org.bukkit.entity.Player;
import org.bukkit.plugin.SimplePluginManager;
import org.bukkit.util.StringUtil;
import org.jetbrains.annotations.NotNull;

import java.lang.reflect.Field;
import java.util.*;

public class CommandBuilder {

    private static final HashMap<String, CommandBuilder> commandList = new HashMap<>();

    String name;
    SenderType senderType = SenderType.EVERYONE;
    ExecutableCommand initCommand;
    ArrayList<String> aliases = new ArrayList<>();
    String description = "Your average command";
    String usageMessage = ChatUtils.legacyString("<red>Incorrect Usage");
    Component wrongSenderMessage;
    String permission;
    String permissionMessage = ChatUtils.legacyString("<red>You are not permitted to do this!");

    /**
     * CommandBuilder factory method
     * @param name Command Name
     * @return Command Builder
     */
    public static CommandBuilder create(String name) {
        return new CommandBuilder(name);
    }

    /**
     * INTERNAL USE ONLY
     * <p>
     * Creates a command builder
     * @param name Command Name
     */
    private CommandBuilder(String name) {
        this.name = name;
    }

    /**
     * Sets SenderType of command
     * @param type Sender Type
     * @return Command Builder
     */
    public CommandBuilder sender(SenderType type) {
        this.senderType = type;
        return this;
    }

    /**
     * Adds the executable command
     * @param executableCommand Executable Command
     * @return Command Builder
     */
    public CommandBuilder executableCommand(ExecutableCommand executableCommand) {
        executableCommand.position(0);
        executableCommand.commandStage(CommandStage.INITIAL);
        this.initCommand = executableCommand;
        return this;
    }

    /**
     * Adds aliases to command
     * @param aliases Aliases
     * @return Command Builder
     */
    public CommandBuilder aliases(String... aliases) {
        Arrays.stream(aliases).forEach(s -> {
            if (!this.aliases.contains(s)) this.aliases.add(s);
        });
        return this;
    }

    /**
     * Sets command description
     * @param description Description
     * @return Command Builder
     */
    public CommandBuilder description(String description) {
        this.description = ChatUtils.legacyString(description);
        return this;
    }

    /**
     * Sets command description
     * @param description Description
     * @return Command Builder
     */
    public CommandBuilder description(Component description) {
        this.description = ChatUtils.toLegacyString(description);
        return this;
    }

    /**
     * Sets usage message
     * @param usageMessage Usage Message
     * @return Command Builder
     */
    public CommandBuilder usageMessage(String usageMessage) {
        this.usageMessage = ChatUtils.legacyString(usageMessage);
        return this;
    }

    /**
     * Sets usage message
     * @param usageMessage Usage Message
     * @return Command Builder
     */
    public CommandBuilder usageMessage(Component usageMessage) {
        this.usageMessage = ChatUtils.toLegacyString(usageMessage);
        return this;
    }

    /**
     * Sets command permission
     * @param permission Permission
     * @return Command Builder
     */
    public CommandBuilder permission(String permission) {
        this.permission = permission;
        return this;
    }

    /**
     * Sets wrong sender message
     * @param wrongSenderMessage Message
     * @return Command Builder
     */
    public CommandBuilder setWrongSenderMessage(String wrongSenderMessage) {
        this.wrongSenderMessage = ChatUtils.getComponent(wrongSenderMessage);
        return this;
    }

    /**
     * Sets wrong sender message
     * @param wrongSenderMessage Message
     * @return Command Builder
     */
    public CommandBuilder setWrongSenderMessage(Component wrongSenderMessage) {
        this.wrongSenderMessage = wrongSenderMessage;
        return this;
    }

    /**
     * Sets command permission message
     * @param permissionMessage Permission message
     * @return Command Builder
     */
    public CommandBuilder permissionMessage(String permissionMessage) {
        this.permissionMessage = ChatUtils.legacyString(permissionMessage);
        return this;
    }

    /**
     * Sets command permission message
     * @param permissionMessage Permission message
     * @return Command Builder
     */
    public CommandBuilder permissionMessage(Component permissionMessage) {
        this.permissionMessage = ChatUtils.toLegacyString(permissionMessage);
        return this;
    }

    public void build() {
        register(getCommand());
    }

    private void register(Command command) {
        getCommandMap().register(this.name, "abundant", command);
    }

    private Command getCommand() {
        Command command = new Command(name) {

            @Override
            public boolean execute(@NotNull CommandSender commandSender, @NotNull String label, @NotNull String[] strings) {

                // Order of Operations:
                // 1st: Subcommands
                // 2nd: Other Arguments

                if (commandSender instanceof Player && senderType == SenderType.CONSOLE) {
                    if (wrongSenderMessage == null)
                        commandSender.sendMessage(ChatUtils.getComponent("&cPlayers are not permitted to perform this command."));
                    else
                        commandSender.sendMessage(wrongSenderMessage);
                    return true;
                }

                if (commandSender instanceof ConsoleCommandSender && senderType == SenderType.PLAYER) {
                    if (wrongSenderMessage == null)
                        commandSender.sendMessage(ChatUtils.getComponent("You may not run this command through console."));
                    else
                        commandSender.sendMessage(wrongSenderMessage);
                    return true;
                }

                if (commandSender instanceof Player) {
                    Player player = (Player) commandSender;
                    if (permission != null && !player.hasPermission(permission)) {
                        player.sendMessage(ChatUtils.getComponent(permissionMessage));
                        return true;
                    }
                }

                CommandExecutor executor = new CommandExecutor()
                        .setCommand(initCommand)
                        .setLabel(label)
                        .setSender(commandSender)
                        .setCurrentPosition(0)
                        .setRawArgs(strings);
                executor.runCommand();

                return true;
            }

            @Override
            public @NotNull List<String> tabComplete(@NotNull CommandSender sender, @NotNull String commandLabel, String[] args) {
                return getTabCompletions(initCommand, 0, args, sender);
            }

        };

        if (permission != null) command.setPermission(permission);
        command.setAliases(aliases);
        command.permissionMessage(ChatUtils.getComponent(permissionMessage));
        command.setUsage(usageMessage);
        command.setDescription(description);

        return command;
    }

    //

    private static List<String> getTabCompletions(ExecutableCommand command, int currentPos, String[] rawArgs, CommandSender sender) {
        ArrayList<String> tabEntries = new ArrayList<>();
        ArrayList<String> filteredTabEntries = new ArrayList<>();
        int currentArgIndex = rawArgs.length - 1;
        int currentArgPos = rawArgs.length;

        for (ExecutableCommand subCommand : command.getExecutableCommands()) {
            if (subCommand.getPermission() != null && !sender.hasPermission(subCommand.getPermission())) continue;

            int subCommandPos = subCommand.getPosition() + currentPos;
            int subCommandIndex = subCommandPos - 1;

            if (subCommandPos == currentArgPos) {
                tabEntries.add(subCommand.getNames().get(0));
            }

            for (String rawArg : rawArgs) {
                if (subCommand.getNames().contains(rawArg.toLowerCase(Locale.ROOT)))
                    return getTabCompletions(subCommand, subCommandPos, rawArgs, sender);
            }
        }

        for (Argument argument : command.getArguments()) {
            int argPos = argument.getPosition() + currentPos;

            if (argPos == currentArgPos) {
                if (argument.getType() == ArgumentType.WORLD) {
                    Bukkit.getWorlds().forEach(world -> tabEntries.add(world.getName()));
                }
                else if (argument.getType() == ArgumentType.PLAYER) {
                    Bukkit.getOnlinePlayers().forEach(player -> tabEntries.add(player.getName()));
                }
                else if (argument.getType() == ArgumentType.BOOLEAN) {
                    tabEntries.add("true");
                    tabEntries.add("false");
                }
                else if (argument.getType() == ArgumentType.CUSTOM) {
                    if (argument.getCustomArgument() != null)
                        tabEntries.addAll(argument.getCustomArgument().getTabCompletions());
                }
                break;
            }
        }

        StringUtil.copyPartialMatches(rawArgs[currentArgIndex], tabEntries, filteredTabEntries);
        return filteredTabEntries;
    }

    private static CommandMap getCommandMap(){
        Field field;
        CommandMap commandMap;

        try {
            (field = SimplePluginManager.class.getDeclaredField("commandMap")).setAccessible(true);
            commandMap = (CommandMap) field.get(Bukkit.getPluginManager());
            return commandMap;
        } catch (ReflectiveOperationException ex) {
            ex.printStackTrace();
        }

        return null;
    }

}
