package net.abundantmc.pvp.mining;

import com.sk89q.worldedit.bukkit.BukkitAdapter;
import com.sk89q.worldedit.regions.Region;
import com.sk89q.worldguard.WorldGuard;
import com.sk89q.worldguard.protection.managers.RegionManager;
import com.sk89q.worldguard.protection.regions.ProtectedRegion;
import com.sk89q.worldguard.protection.regions.RegionContainer;
import dev.triumphteam.gui.builder.item.ItemBuilder;
import net.abundantmc.abundantlibrary.spigotlibrary.file.PluginFile;
import net.abundantmc.abundantlibrary.spigotlibrary.utilities.AudienceUtils;
import net.abundantmc.pvp.AbundantPlugin;
import net.abundantmc.pvp.gear.GearManager;
import net.abundantmc.pvp.gear.Pickaxe;
import net.abundantmc.pvp.miscellaneous.constants.NSKey;
import org.bukkit.*;
import org.bukkit.block.data.BlockData;
import org.bukkit.configuration.ConfigurationSection;
import org.bukkit.entity.Player;
import org.bukkit.event.EventHandler;
import org.bukkit.event.Listener;
import org.bukkit.event.block.BlockBreakEvent;
import org.bukkit.inventory.ItemStack;
import org.bukkit.inventory.meta.ItemMeta;
import org.bukkit.persistence.PersistentDataContainer;
import org.bukkit.plugin.Plugin;
import org.bukkit.scheduler.BukkitRunnable;

import java.util.Map;
import java.util.Random;
import java.util.UUID;

public class MiningListener implements Listener {
    private final GearManager gearManager = new GearManager();
    private final ProtectedRegion safecaveRegion = initializeRegion();
    private final Plugin plugin = AbundantPlugin.getPlugin();
    private final PluginFile file = new PluginFile(AbundantPlugin.getPlugin(), "safecave-blocks");

    @EventHandler
    public void onMine(BlockBreakEvent event) {
        Player player = event.getPlayer();
        if (player.getGameMode() != GameMode.SURVIVAL) return;
        if (event.isCancelled()) return;

        if (eventInSafecaveRegion(event)) {
            handleSafecaveMine(player, event);
        } else {
            handlePvpMapMine(player, event);
        }
    }

    private void handlePvpMapMine(Player player, BlockBreakEvent event) {
        Material type = event.getBlock().getType();
        Ore ore = Ore.fromOreBlock(type);
        if (ore == null) {
            event.setCancelled(true);
            return;
        }

        ItemStack itemStack = player.getInventory().getItemInMainHand();
        Pickaxe pickaxe = Pickaxe.fromPickaxeType(itemStack.getType());
        if (pickaxe == null) {
            event.setCancelled(true);
            return;
        }

        int oreLevel = ore.getPickaxeLevel();
        if (ore.getPickaxeLevel() > pickaxe.getMiningLevel()) {
            Pickaxe requiredPickaxe = Pickaxe.fromMiningLevel(oreLevel);
            AudienceUtils.error(player, "This ore requires " + aOrAn(requiredPickaxe.getDisplay()) + " " + requiredPickaxe.getDisplay() + " to mine [Level " + (((oreLevel - 1) * 10) + 1) + "+]");

            event.setCancelled(true);
            return;
        }

        handleDropsAndUpgrade(player, event, ore, itemStack);
    }

    private boolean eventInSafecaveRegion(BlockBreakEvent event) {
        Location location = event.getBlock().getLocation();
        return safecaveRegion.contains(location.getBlockX(), location.getBlockY(), location.getBlockZ());
    }

    private void handleSafecaveMine(Player player, BlockBreakEvent event) {
        Material type = event.getBlock().getType();
        Ore ore = Ore.fromOreBlock(type);
        if (ore == null) {
            event.setCancelled(true);
            return;
        }

        ItemStack itemStack = player.getInventory().getItemInMainHand();
        Pickaxe pickaxe = Pickaxe.fromPickaxeType(itemStack.getType());
        if (pickaxe == null) {
            event.setCancelled(true);
            return;
        }

        handleBlockReplacement(event);
        handleDropsAndUpgrade(player, event, ore, itemStack);
    }

    private void handleBlockReplacement(BlockBreakEvent event) {
        UUID randomUUID = UUID.randomUUID();
        ConfigurationSection section = file.getFileEditor().createSection(randomUUID.toString());
        Material material = event.getBlock().getType();
        Location location = event.getBlock().getLocation();

        section.set("location", location);
        section.set("material", material.toString());
        file.save();

        new BukkitRunnable() {
            @Override
            public void run() {
                location.getBlock().setType(Material.BEDROCK);
            }
        }.runTaskLater(plugin, 1);

        new BukkitRunnable() {
            @Override
            public void run() {
                location.getBlock().setType(material);
                file.clear(randomUUID.toString());
            }
        }.runTaskLater(plugin, 20 * 30);
    }

    private ProtectedRegion initializeRegion() {
        RegionContainer container = WorldGuard.getInstance().getPlatform().getRegionContainer();
        RegionManager manager = container.get(BukkitAdapter.adapt(Bukkit.getWorld("pvpworld")));
        return manager.getRegion("safecave");
    }

    private void handleDropsAndUpgrade(Player player, BlockBreakEvent event, Ore ore, ItemStack itemStack) {
        ItemMeta itemMeta = itemStack.getItemMeta();
        if (itemMeta == null) return;

        PersistentDataContainer persistentDataContainer = itemMeta.getPersistentDataContainer();
        if (!persistentDataContainer.has(NSKey.PICKAXE.getNamespacedKey())) return;

        int itemAmount = 1;
        int xpAmount = 1;

        event.setDropItems(false);
        event.setExpToDrop(0);
        gearManager.increaseToolXp(player, ore.getXp());

        if ((int) (Math.random() * 100) < 2)
            player.giveExp(xpAmount);

        AudienceUtils.playSound(player, Sound.ENTITY_ARROW_HIT_PLAYER, new Random().nextFloat(1.9f, 2f));

        Map<Integer, ItemStack> leftOverItems = player.getInventory().addItem(ItemBuilder.from(ore.getDrop()).amount(itemAmount).build());
        if (!leftOverItems.isEmpty()) {
            AudienceUtils.playSound(player, Sound.ENTITY_VILLAGER_NO, 1);
            AudienceUtils.sendTitle(player, "<dark_red><b>INVENTORY FULL", "<red>Items will drop on the ground when your inventory is full!", 5, 60, 5);
            for (ItemStack loopItem : leftOverItems.values()) {
                player.getWorld().dropItem(event.getBlock().getLocation(), loopItem);
            }
        }
    }

    public String aOrAn(String afterString) {
        char c = afterString.toLowerCase().charAt(0);
        if (c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u')
            return "an";
        return "a";
    }
}
