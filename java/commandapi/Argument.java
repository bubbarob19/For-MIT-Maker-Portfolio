package net.abundantmc.abundantlibrary.spigotlibrary.command;

import net.abundantmc.abundantlibrary.spigotlibrary.utilities.ChatUtils;
import net.kyori.adventure.text.Component;

public class Argument {

    private int position = 1;
    private ArgumentType type = ArgumentType.STRING;
    private boolean optional;
    private String defaultValue = "null";
    private ArgumentCheck check = o -> true;
    private Component errorMsg = ChatUtils.getErrorMessage("You entered an invalid argument!");
    private CustomArgument customArgument;
    private SenderContext context = (s, a) -> true;

    /**
     * INTERNAL USE ONLY
     * <p>
     * Private Constructor
     * @return Argument Builder
     */
    private Argument() {}

    /**
     * Factory Argument Builder Creator
     * @return Argument Builder
     */
    public static Argument create() { return new Argument(); }

    /**
     * Position of the argument
     * @param position Argument Position
     * @return Argument Builder
     */
    public Argument position(int position) {
        this.position = position;
        return this;
    }

    /**
     * Type of the argument
     * @param type Argument Type
     * @return Argument Builder
     */
    public Argument type(ArgumentType type) {
        this.type = type;
        return this;
    }

    /**
     * How the argument is checked before command execution
     * @param check Check
     * @return Argument Builder
     */
    public Argument check(ArgumentCheck check) {
        this.check = check;
        return this;
    }

    /**
     * How the sender is checked for the specific argument
     * @param context Context
     * @return Argument Builder
     */
    public Argument context(SenderContext context) {
        this.context = context;
        return this;
    }

    /**
     * Error msg if check fails
     * @param errorMsg Error Message
     * @return Argument Builder
     */
    public Argument errorMsg(Component errorMsg) {
        this.errorMsg = errorMsg;
        return this;
    }

    /**
     * Error msg if check fails
     * @param errorMsg Error Message
     * @return Argument Builder
     */
    public Argument errorMsg(String errorMsg) {
        this.errorMsg = ChatUtils.getComponent(errorMsg);
        return this;
    }

    /**
     * Sets whether argument is optional
     * @param optional Boolean
     * @return Argument Builder
     */
    public Argument optional(boolean optional) {
        this.optional = optional;
        return this;
    }

    /**
     * Sets default value of Argument
     * @param defaultValue Default Value
     * @return Argument Builder
     */
    public Argument defaultValue(String defaultValue) {
        this.defaultValue = defaultValue;
        return this;
    }

    /**
     * Sets the custom argument of the Argument
     * @param customArgument Custom Argument
     * @return Argument Builder
     */
    public Argument customArgument(CustomArgument customArgument) {
        this.customArgument = customArgument;
        return this;
    }

    public CustomArgument getCustomArgument() {
        return customArgument;
    }

    public int getPosition() {
        return position;
    }

    public ArgumentType getType() {
        return type;
    }

    public ArgumentCheck getCheck() {
        return check;
    }

    public Component getErrorMsg() {
        return errorMsg;
    }

    public boolean isOptional() {
        return optional;
    }

    public String getDefaultValue() {
        return defaultValue;
    }

    public SenderContext getContext() {
        return context;
    }
}
