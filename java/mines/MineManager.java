package net.abundantmc.pvp.mining;

import net.abundantmc.abundantlibrary.spigotlibrary.file.PluginFile;
import net.abundantmc.abundantlibrary.spigotlibrary.utilities.AudienceUtils;
import net.abundantmc.pvp.AbundantPlugin;
import org.bukkit.Bukkit;
import org.bukkit.Location;
import org.bukkit.Material;
import org.bukkit.configuration.ConfigurationSection;
import org.bukkit.entity.Player;
import org.bukkit.plugin.Plugin;
import org.bukkit.scheduler.BukkitRunnable;
import org.bukkit.scheduler.BukkitTask;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

public class MineManager {
    private static MineManager instance;

    private Plugin plugin = AbundantPlugin.getPlugin();
    private PluginFile file = new PluginFile(plugin, "mines");
    private BukkitTask resetTask;
    private List<Mine> mines;

    public static MineManager getInstance() {
        if (instance == null) {
            instance = new MineManager();
            instance.initializeMinesList();
            instance.loadAll();
        }
        return instance;
    }

    private MineManager() {}

    public void addMine(Mine mine) {
        mines.add(mine);
    }

    public void removeMine(Mine mine) {
        mines.remove(mine);
    }

    private void initializeMinesList() {
        mines = new ArrayList<>();
        ConfigurationSection section = file.getFileEditor();
        for (String key : section.getKeys(false)) {
            Mine mine = Mine.fromFile(key);
            if (mine != null)
                mines.add(mine);
        }
    }

    public void loadAll() {
        for (Mine mine : mines) {
            mine.load();
        }
        if (resetTask == null)
            startMineLoop();
    }

    public void unloadAll() {
        for (Mine mine : mines) {
            mine.unload();
            mine.save();
        }
        resetTask.cancel();
    }

    private void startMineLoop() {
        resetTask = new BukkitRunnable() {
            @Override
            public void run() {
                AudienceUtils.sendMsg(AudienceUtils.ofAllPlayers(), "<dark_gray>[<dark_red><b>!<dark_gray><!b>] <dot> <red>Mines are resetting, expect lag!");
                for (Mine mine : mines) {
                    mine.reset();
                    for (Player player : Bukkit.getOnlinePlayers()) {
                        Location loc = mine.getTeleportPlayerLocation();
                        if (mine.playerIsInRegion(player)) {
                            player.teleport(loc);
                        }
                    }
                }
            }
        }.runTaskTimer(plugin, 20 * 60 * 3, 20 * 60 * 3);
    }

    public List<Mine> getMines() {
        return mines;
    }

    public boolean isAMine(String id) {
        for (Mine loopMine : mines) {
            if (loopMine.getId().equals(id))
                return true;
        }
        return false;
    }

    public Mine fromId(String id) {
        for (Mine mine : mines) {
            if (mine.getId().equals(id))
                return mine;
        }
        return null;
    }
}
