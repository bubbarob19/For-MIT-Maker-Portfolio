package me.bubbarob19.wipeout.minigame;

import me.bubbarob19.wipeout.Main;
import me.bubbarob19.wipeout.utils.Utils;
import net.md_5.bungee.api.ChatMessageType;
import net.md_5.bungee.api.chat.TextComponent;
import org.bukkit.Material;
import org.bukkit.block.BlockFace;
import org.bukkit.entity.Arrow;
import org.bukkit.entity.EntityType;
import org.bukkit.entity.Player;
import org.bukkit.event.EventHandler;
import org.bukkit.event.Listener;
import org.bukkit.event.entity.PlayerDeathEvent;
import org.bukkit.event.entity.ProjectileHitEvent;
import org.bukkit.event.player.PlayerMoveEvent;
import org.bukkit.scheduler.BukkitRunnable;
import org.bukkit.util.Vector;

public class FailListener implements Listener {

    @EventHandler
    public void onHitLiquid(PlayerMoveEvent event) {

        Player player = event.getPlayer();
        Game game = Game.getGameFromPlayer(player);

        if (game == null) return;
        if (game.getGameState() != GameState.INGAME) return;
        Material blockType = player.getLocation().getBlock().getType();
        if (!(blockType == Material.WATER || blockType == Material.LAVA)) return;

        player.teleport(game.getCheckpoint().getLocation());
        player.spigot().sendMessage(ChatMessageType.ACTION_BAR, new TextComponent(Utils.format("&bOh no! You fell!")));
    }

    @EventHandler
    public void onProjectileHitPlayer(ProjectileHitEvent event) {
        if (event.getHitEntity() == null) return;
        if (event.getHitEntity().getType() != EntityType.PLAYER) return;
        if (event.getEntity().getType() != EntityType.SNOWBALL) return;
        Player player = (Player) event.getHitEntity();
        Game game = Game.getGameFromPlayer(player);
        if (game == null) return;
        if (game.getGameState() != GameState.INGAME) return;

        player.setVelocity(new Vector(0, 0, BlockFace.SOUTH.getModZ() * 5));

        new BukkitRunnable() {
            @Override
            public void run() {
                player.setVelocity(new Vector(0, 0, 0));
                player.spigot().sendMessage(ChatMessageType.ACTION_BAR, new TextComponent(Utils.format("&bOh no! You were mutilated by a snowball!")));
                player.teleport(game.getCheckpoint().getLocation());
            }
        }.runTaskLater(Main.getInstance(), 12);
    }

    @EventHandler
    public void onDeath(PlayerDeathEvent event) {
        Player player = event.getEntity().getPlayer();

        event.setDeathMessage("");

        Game game = Game.getGameFromPlayer(player);
        if (game == null) return;
        if (game.getGameState() != GameState.INGAME) return;

        new BukkitRunnable() {
            @Override
            public void run() {
                player.teleport(game.getCheckpoint().getLocation());
                player.spigot().sendMessage(ChatMessageType.ACTION_BAR, new TextComponent(Utils.format("&bOh no! You died!")));
            }
        }.runTaskLater(Main.getInstance(), 2);
    }

}
