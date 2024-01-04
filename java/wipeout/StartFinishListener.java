package me.bubbarob19.wipeout.minigame;

import com.sk89q.worldedit.bukkit.BukkitAdapter;
import com.sk89q.worldedit.math.BlockVector3;
import com.sk89q.worldedit.world.World;
import com.sk89q.worldguard.WorldGuard;
import com.sk89q.worldguard.protection.ApplicableRegionSet;
import com.sk89q.worldguard.protection.managers.RegionManager;
import com.sk89q.worldguard.protection.regions.ProtectedRegion;
import com.sk89q.worldguard.protection.regions.RegionContainer;
import com.sk89q.worldguard.protection.regions.RegionQuery;
import me.bubbarob19.wipeout.utils.Utils;
import org.bukkit.Bukkit;
import org.bukkit.Material;
import org.bukkit.entity.Player;
import org.bukkit.event.EventHandler;
import org.bukkit.event.Listener;
import org.bukkit.event.block.Action;
import org.bukkit.event.player.PlayerInteractEvent;
import org.bukkit.event.player.PlayerMoveEvent;

public class StartFinishListener implements Listener {

    private static RegionContainer container = WorldGuard.getInstance().getPlatform().getRegionContainer();
    private static RegionManager regions = container.get(BukkitAdapter.adapt(Bukkit.getWorld("void")));

    @EventHandler
    public void onPressurePlateInteract(PlayerInteractEvent event) {

        Player player = event.getPlayer();
        if (event.getAction() != Action.PHYSICAL) return;

        RegionQuery query = container.createQuery();
        ApplicableRegionSet set = query.getApplicableRegions(BukkitAdapter.adapt(player.getLocation()));

        for (ProtectedRegion region : set) {
            if (region.getId().equals("start")) {
                Game game = new Game(player);
                game.start();
                return;
            }
            if (region.getId().equals("finish")) {
                Game game = Game.getGameFromPlayer(player);
                if (game == null) return;
                if (game.getCheckpoint().getNumber() != 5) return;
                if (game.getGameState() != GameState.INGAME) return;
                game.complete();
                return;
            }
        }

        for (Checkpoint checkpoint : CheckpointManager.getCheckpoints()) {
            Game game = Game.getGameFromPlayer(player);
            if (game == null) return;
            if (checkpoint.getLocation().distance(player.getLocation()) < 2) {
                if (game.getCheckpoint().getNumber() + 1 != checkpoint.getNumber()) continue;
                game.setCheckpoint(checkpoint);
                Utils.send(player, "&8• &fYou advanced to checkpoint &b" + checkpoint.getNumber() + "&f!");
                Utils.playSound(player, "block.note_block.chime", 1, 2);
                return;
            }
        }

    }

    @EventHandler
    public void onMove(PlayerMoveEvent event) {
        Player player = event.getPlayer();
        Game game = Game.getGameFromPlayer(player);

        if (game == null) return;
        if (game.getGameState() != GameState.COOLDOWN) return;

        event.setCancelled(true);
    }

}
