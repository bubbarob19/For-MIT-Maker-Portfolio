package me.bubbarob19.wipeout.misc;

import com.xxmicloxx.NoteBlockAPI.model.RepeatMode;
import com.xxmicloxx.NoteBlockAPI.model.Song;
import com.xxmicloxx.NoteBlockAPI.songplayer.RadioSongPlayer;
import com.xxmicloxx.NoteBlockAPI.utils.NBSDecoder;
import me.bubbarob19.wipeout.Main;
import me.bubbarob19.wipeout.data.PlayerData;
import org.bukkit.Bukkit;
import org.bukkit.entity.Player;
import org.bukkit.event.EventHandler;
import org.bukkit.event.Listener;
import org.bukkit.event.player.PlayerJoinEvent;
import org.bukkit.event.player.PlayerQuitEvent;
import org.bukkit.scheduler.BukkitRunnable;

import java.io.File;
import java.util.HashMap;

public class MusicLoader implements Listener {

    private static final HashMap<Player, RadioSongPlayer> SONG_PLAYERS = new HashMap<>();

    @EventHandler
    public void onJoin(PlayerJoinEvent event) {
        Player player = event.getPlayer();
        if (PlayerData.getFromUUID(player.getUniqueId()).getMusicStatus()) {
            new BukkitRunnable() {
                @Override
                public void run() {
                    if (SONG_PLAYERS.containsKey(player)) return;
                    if (!PlayerData.getFromUUID(player.getUniqueId()).getMusicStatus()) return;
                    runMusic(player, "wipeout");
                }
            }.runTaskLater(Main.getInstance(), 30);
        }
    }

    @EventHandler
    public void onQuit(PlayerQuitEvent event) {
        stopMusic(event.getPlayer());
    }

    public void runMusic(Player player, String songname) {
        if (SONG_PLAYERS.get(player) != null)
            return;
        Song song = NBSDecoder.parse(new File(Bukkit.getServer().getPluginManager().getPlugin("WipeoutPlugin").getDataFolder(), songname + ".nbs"));
        RadioSongPlayer rsp = new RadioSongPlayer(song);
        SONG_PLAYERS.put(player, rsp);
        rsp.addPlayer(player);
        rsp.setPlaying(true);
        rsp.setRepeatMode(RepeatMode.ONE);
    }

    public void stopMusic(Player player) {
        RadioSongPlayer rsp = SONG_PLAYERS.get(player);
        if (rsp != null) {
            SONG_PLAYERS.remove(player);
            rsp.destroy();
        }
    }

}
