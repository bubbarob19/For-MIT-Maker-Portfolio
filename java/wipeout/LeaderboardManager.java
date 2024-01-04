package me.bubbarob19.wipeout.minigame;

import com.gmail.filoghost.holographicdisplays.api.Hologram;
import com.gmail.filoghost.holographicdisplays.api.HologramsAPI;
import me.bubbarob19.wipeout.Main;
import me.bubbarob19.wipeout.core.Warps;
import me.bubbarob19.wipeout.data.PluginFile;
import me.bubbarob19.wipeout.utils.Utils;
import org.bukkit.Bukkit;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

public class LeaderboardManager {

    private static final Main PLUGIN = Main.getInstance();
    private static Hologram hologram;
    private static PluginFile file = new PluginFile("leaderboards");
    private static ConcurrentHashMap<Integer, LeaderboardEntry> entries = new ConcurrentHashMap<>();

    // Holograms

    public void loadHologram() {
        hologram = HologramsAPI.createHologram(PLUGIN, new Warps().getWarp("leaderboards"));
        hologram.setAllowPlaceholders(true);
        hologram.appendTextLine(Utils.format("&3&lWIPEOUT LEADERBOARDS"));
        for (int x = 1; x < 11; x++) {
            hologram.appendTextLine("{leaderboard:" + x + "}");
        }
    }

    public void deleteHologram() {
        if (hologram == null) return;
        hologram.delete();
        hologram = null;
    }

    public void loadEntries() {
        for (int x = 1; x < 11; x++) {
            if (file.containsKey("entry." + x)) {
                int minutes = (int) file.get("entry." + x + ".minutes");
                int seconds = (int) file.get("entry." + x + ".seconds");
                String uuid = (String) file.get("entry." + x + ".uuid");
                LeaderboardEntry entry = new LeaderboardEntry(uuid, minutes, seconds);
                entries.put(x, entry);
            }
        }
    }

    public void addEntry(LeaderboardEntry entry) {
        ConcurrentHashMap<Integer, LeaderboardEntry> newEntrySet = new ConcurrentHashMap<>();
        // If player is already on LB and their time is less than or equal to the new time STOP
        int playerEntryNum = 0;
        for (Map.Entry<Integer, LeaderboardEntry> oldEntry : entries.entrySet()) {
            if (!oldEntry.getValue().getUUID().equals(entry.getUUID())) continue;
            if (oldEntry.getValue().getMinutes() < entry.getMinutes() || (oldEntry.getValue().getMinutes() == entry.getMinutes() && oldEntry.getValue().getSeconds() <= entry.getSeconds())) {
                return;
            }
            playerEntryNum = oldEntry.getKey();
            break;
        }
        // Loop through entries and set leaderboards accordingly
        if (playerEntryNum != 0)  {
            entries.remove(playerEntryNum);
            int highestValue = 0;
            for (Map.Entry<Integer, LeaderboardEntry> oldEntry : entries.entrySet()) {
                if (oldEntry.getKey() > playerEntryNum) {
                    if (oldEntry.getKey() > highestValue) highestValue = oldEntry.getKey();
                    entries.put(oldEntry.getKey() - 1, oldEntry.getValue());
                }
            }
            if (highestValue > 1) entries.remove(highestValue);
        }
        int entryPlace = 1;
        for (Map.Entry<Integer, LeaderboardEntry> oldEntry : entries.entrySet()) {
            LeaderboardEntry oldLeaderboardEntry = oldEntry.getValue();
            int oldLeaderboardPlace = oldEntry.getKey();
            if (oldLeaderboardEntry.getMinutes() < entry.getMinutes() || (oldLeaderboardEntry.getMinutes() == entry.getMinutes() && oldLeaderboardEntry.getSeconds() <= entry.getSeconds())) {
                entryPlace++;
                newEntrySet.put(oldLeaderboardPlace, oldLeaderboardEntry);
            }
            else {
                if (oldLeaderboardPlace < 10)
                    newEntrySet.put(oldLeaderboardPlace + 1, oldLeaderboardEntry);
            }
        }

        if (entryPlace <= 10)
            newEntrySet.put(entryPlace, entry);
        entries = newEntrySet;
    }

    public void save() {
        for (Map.Entry<Integer, LeaderboardEntry> entry : entries.entrySet()) {
            int place = entry.getKey();
            LeaderboardEntry leaderboardEntry = entry.getValue();
            if (place > 10) continue;
            file.set("entry." + place + ".minutes", leaderboardEntry.getMinutes());
            file.set("entry." + place + ".seconds", leaderboardEntry.getSeconds());
            file.set("entry." + place + ".uuid", leaderboardEntry.getUUID().toString());
        }
    }

    protected static String getFormattedEntry(int minutes, int seconds) {
        String minuteString = "" + minutes;
        String secondString = "" + seconds;
        if (seconds < 10)
            secondString = "0" + seconds;
        return (minuteString + ":" + secondString);
    }

    protected static LeaderboardEntry getEntry(int entry) {
        return entries.get(entry);
    }

}
