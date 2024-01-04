package me.bubbarob19.wipeout.minigame;

import me.bubbarob19.wipeout.Main;
import me.bubbarob19.wipeout.data.PluginFile;
import org.bukkit.Location;

import java.util.ArrayList;

public class CheckpointManager {

    private static final ArrayList<Checkpoint> CHECKPOINTS = new ArrayList<>();
    private static final PluginFile FILE = new PluginFile("checkpoints");

    public void loadCheckpoints() {
        for (String key : FILE.getFileEditor().getConfigurationSection("checkpoints").getKeys(false)) {
            try {
                Main.getInstance().getLogger().info(key);
                String replacedKey = key.replace("checkpoints.", "");
                Main.getInstance().getLogger().info(replacedKey);
                int number = Integer.parseInt(replacedKey);
                Location location = (Location) FILE.get("checkpoints." + key);
                Checkpoint checkpoint = new Checkpoint(number, location);
                Main.getInstance().getLogger().info(location.toString() + "\n" + replacedKey);
                CHECKPOINTS.add(checkpoint);
            }
            catch (Exception exception) {
                exception.printStackTrace();
            }
        }
    }

    public void saveCheckpoints() {
        for (Checkpoint checkpoint : CHECKPOINTS) {
            FILE.set("checkpoints." + checkpoint.getNumber(), checkpoint.getLocation());
        }
    }

    public void addCheckpoint(int number, Location location) {
        CHECKPOINTS.add(new Checkpoint(number, location));
        saveCheckpoints();
    }

    public void addCheckpoint(Checkpoint checkpoint) {
        CHECKPOINTS.add(checkpoint);
        saveCheckpoints();
    }

    public Checkpoint getCheckpoint(int number) {
        for (Checkpoint checkpoint : CHECKPOINTS) {
            if (checkpoint.getNumber() == number) return checkpoint;
        }
        return null;
    }

    public static ArrayList<Checkpoint> getCheckpoints() { return (ArrayList<Checkpoint>) CHECKPOINTS.clone(); }

    public void removeCheckpoint(int number) {
        CHECKPOINTS.remove(number);
        FILE.clear("checkpoints." + number);
    }

}
