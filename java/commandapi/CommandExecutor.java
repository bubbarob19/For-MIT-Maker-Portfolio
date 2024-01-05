package net.abundantmc.abundantlibrary.spigotlibrary.command;

import org.bukkit.Bukkit;
import org.bukkit.command.CommandSender;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Locale;

public class CommandExecutor {

    ExecutableCommand command;
    CommandSender sender;
    String label;
    String[] rawArgs;
    int currentPosition;
    ArrayList<Object> processedArgs = new ArrayList<>();

    public void runCommand() {
        if (command.commandStage == CommandStage.SUB) {
            if (command.getPermission() != null && !sender.hasPermission(command.getPermission())) {
                sender.sendMessage(command.getPermissionMessage());
                return;
            }
        }

        if (rawArgs.length <= currentPosition && command.getArguments().stream().anyMatch(argument -> !argument.isOptional())) {
            sender.sendMessage(command.getHelpMessage());
            return;
        }

        int subCommandExistsPosition = 0;
        ExecutableCommand existingSubCommand = null;

        for (ExecutableCommand subCommand : command.getExecutableCommands()) {
            int subPos = subCommand.getPosition() + currentPosition;
            if (rawArgs.length < subPos) continue;
            if (!subCommand.getNames().contains(rawArgs[subPos - 1].toLowerCase(Locale.ROOT))) continue;

            existingSubCommand = subCommand;
            subCommandExistsPosition = subPos;
            break;
        }

        for (Argument argument : command.getArguments()) {
            int argPos = argument.getPosition() + currentPosition;

            if (existingSubCommand != null && subCommandExistsPosition == argPos) {
                processedArgs.add(rawArgs[argPos - 1]);
                CommandExecutor executor = new CommandExecutor()
                        .setRawArgs(rawArgs)
                        .setCommand(existingSubCommand)
                        .setCurrentPosition(argPos)
                        .setLabel(label)
                        .setSender(sender)
                        .setProcessedArgs(processedArgs);
                executor.runCommand();

                return;
            }

            if (rawArgs.length < argPos && !argument.isOptional()) {
                sender.sendMessage(argument.getErrorMsg());
                return;
            }
            Object object = parse(argument);
            if (!argument.isOptional()) {
                if (object == null) {
                    sender.sendMessage(argument.getErrorMsg());
                    return;
                }
                if (!argument.getCheck().check(object)) {
                    sender.sendMessage(argument.getErrorMsg());
                    return;
                }
                if (!argument.getContext().checkContext(sender, object)) {
                    sender.sendMessage(argument.getErrorMsg());
                    return;
                }
            }

            processedArgs.add(object);
        }

        if (existingSubCommand != null) {
            processedArgs.add(rawArgs[subCommandExistsPosition - 1]);
            CommandExecutor executor = new CommandExecutor()
                    .setRawArgs(rawArgs)
                    .setCommand(existingSubCommand)
                    .setCurrentPosition(subCommandExistsPosition)
                    .setLabel(label)
                    .setSender(sender)
                    .setProcessedArgs(processedArgs);
            executor.runCommand();

            return;
        }

        Object[] commandObjects = new Object[processedArgs.size() + 1];
        commandObjects[0] = label;
        for (int i = 0; i < processedArgs.size(); i++)
            commandObjects[i + 1] = processedArgs.get(i);

        command.getExecutable().execute(commandObjects, sender);

    }

    private Object parse(Argument argument) {
        ArgumentType type = argument.getType();
        int index = argument.getPosition() + currentPosition - 1;
        String toBeParsed = argument.getDefaultValue();
        if (rawArgs.length > index) toBeParsed = rawArgs[index];
        try {
            if (type == ArgumentType.BOOLEAN) {
                return Boolean.parseBoolean(toBeParsed);
            }
            if (type == ArgumentType.FLOAT) {
                return Float.parseFloat(toBeParsed);
            }
            if (type == ArgumentType.INT) {
                return Integer.parseInt(toBeParsed);
            }
            if (type == ArgumentType.WORD) {
                return toBeParsed;
            }
            if (type == ArgumentType.WORLD) {
                return Bukkit.getWorld(toBeParsed);
            }
            if (type == ArgumentType.PLAYER) {
                return Bukkit.getPlayer(toBeParsed);
            }
            if (type == ArgumentType.OFFLINE_PLAYER) {
                return Bukkit.getOfflinePlayer(toBeParsed);
            }
            if (type == ArgumentType.STRING) {
                if (toBeParsed.equals(argument.getDefaultValue())) return argument.getDefaultValue();
                return String.join(" ", Arrays.copyOfRange(rawArgs, index, rawArgs.length));
            }
            if (type == ArgumentType.CUSTOM) {
                if (argument.getCustomArgument() != null)
                    return argument.getCustomArgument().parse(toBeParsed);
                return toBeParsed;
            }
        }
        catch (Exception e) {
            return null;
        }
        return null;
    }

    // Getter and Setters

    public ExecutableCommand getCommand() {
        return command;
    }

    public CommandExecutor setCommand(ExecutableCommand command) {
        this.command = command;
        return this;
    }

    public CommandSender getSender() {
        return sender;
    }

    public CommandExecutor setSender(CommandSender sender) {
        this.sender = sender;
        return this;
    }

    public String getLabel() {
        return label;
    }

    public CommandExecutor setLabel(String label) {
        this.label = label;
        return this;
    }

    public String[] getRawArgs() {
        return rawArgs;
    }

    public CommandExecutor setRawArgs(String[] rawArgs) {
        this.rawArgs = rawArgs;
        return this;
    }

    public int getCurrentPosition() {
        return currentPosition;
    }

    public CommandExecutor setCurrentPosition(int currentPosition) {
        this.currentPosition = currentPosition;
        return this;
    }

    public ArrayList<Object> getProcessedArgs() {
        return processedArgs;
    }

    public CommandExecutor setProcessedArgs(ArrayList<Object> processedArgs) {
        this.processedArgs = processedArgs;
        return this;
    }
}
