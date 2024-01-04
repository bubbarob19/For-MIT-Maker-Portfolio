package net.abundantmc.pvp.mining;

import com.sk89q.worldedit.bukkit.BukkitAdapter;
import com.sk89q.worldedit.math.BlockVector3;
import com.sk89q.worldedit.regions.CuboidRegion;
import com.sk89q.worldguard.WorldGuard;
import com.sk89q.worldguard.protection.flags.Flag;
import com.sk89q.worldguard.protection.flags.Flags;
import com.sk89q.worldguard.protection.flags.StateFlag;
import com.sk89q.worldguard.protection.managers.RegionManager;
import com.sk89q.worldguard.protection.regions.ProtectedCuboidRegion;
import com.sk89q.worldguard.protection.regions.ProtectedRegion;
import com.sk89q.worldguard.protection.regions.RegionContainer;
import eu.decentsoftware.holograms.api.DHAPI;
import eu.decentsoftware.holograms.api.holograms.Hologram;
import net.abundantmc.abundantlibrary.spigotlibrary.file.PluginFile;
import net.abundantmc.pvp.AbundantPlugin;
import net.abundantmc.pvp.miscellaneous.RandomValueGenerator;
import org.bukkit.Location;
import org.bukkit.Material;
import org.bukkit.World;
import org.bukkit.block.Block;
import org.bukkit.configuration.ConfigurationSection;
import org.bukkit.entity.Player;
import org.bukkit.plugin.Plugin;

import java.util.ArrayList;
import java.util.List;

public class Mine {
    private static final String mineSuffix = "_pvpMine";

    private static Plugin plugin;
    private static PluginFile file;

    private final Location loc1;
    private final Location loc2;
    private final String displayName;
    private final String id;
    private final List<MineComponent> mineComponentList;
    private final List<Block> blocks;
    private final boolean isLoaded = false;
    private Hologram hologram;
    private ProtectedRegion region;
    private RegionManager regions;
    private final RandomValueGenerator<Ore> oreRandomValueGenerator;

    public Mine(Location loc1, Location loc2, String id, String displayName, List<MineComponent> mineComponentList) {
        this.loc1 = loc1;
        this.loc2 = loc2;
        this.id = id;
        this.displayName = displayName;
        this.mineComponentList = mineComponentList;
        this.oreRandomValueGenerator = new RandomValueGenerator<>(mineComponentList);
        this.blocks = blocksFromTwoPoints(loc1, loc2);
        initializeRegion();
    }

    private static void initFile() {
        plugin = AbundantPlugin.getPlugin();
        file = new PluginFile(plugin, "mines");
    }

    public static Mine fromFile(String key) {
        if (plugin == null)
            initFile();

        ConfigurationSection section = file.getFileEditor();
        if (!section.contains(key))
            return null;

        Location loc1 = section.getLocation(key + ".loc1");
        Location loc2 = section.getLocation(key + ".loc2");
        String displayName = section.getString(key + ".displayName");
        List<MineComponent> mineComs = new ArrayList<>();
        ConfigurationSection innerSection = section.getConfigurationSection(key + ".mineComponents");
        for (String innerKey : innerSection.getKeys(false)) {
            Ore ore = Ore.valueOf(innerKey.toUpperCase());
            int percent = innerSection.getInt(innerKey);
            MineComponent mineComponent = new MineComponent(percent, ore);
            mineComs.add(mineComponent);
        }
        return new Mine(loc1, loc2, key, displayName, mineComs);
    }

    public Location getLoc1() {
        return loc1;
    }

    public Location getLoc2() {
        return loc2;
    }

    public String getDisplayName() {
        return displayName;
    }

    public String getId() {
        return id;
    }

    public List<MineComponent> getMineComponentList() {
        return mineComponentList;
    }

    public void save() {
        if (plugin == null)
            initFile();

        ConfigurationSection section = file.getFileEditor().createSection(id);
        section.set("loc1", loc1);
        section.set("loc2", loc2);
        section.set("displayName", displayName);
        ConfigurationSection innerSection = section.createSection("mineComponents");
        for (MineComponent mineComponent : mineComponentList) {
            innerSection.set(mineComponent.getValue().name(), mineComponent.getPercent());
        }

        file.save();
    }

    public void load() {
        if (isLoaded)
            return;
        hologram = DHAPI.createHologram(id + mineSuffix, getHologramLocation());
        DHAPI.addHologramLine(hologram, "&b&l" + displayName);
        for (MineComponent mineComponent : mineComponentList) {
            DHAPI.addHologramLine(hologram, "&8[&f" + mineComponent.getPercent() + "% " + mineComponent.getValue().getOreDisplay() + "&8]");
        }
    }

    public void unload() {
        if (!isLoaded)
            return;
        hologram.delete();
        hologram = null;
    }

    public void reset() {
        for (Block block : blocks) {
            block.setType(getRandomOre());
        }
    }

    public void delete() {
        regions.removeRegion(region.getId());

        if (hologram != null) {
            hologram.delete();
            hologram = null;
        }
    }

    public void initializeRegion() {
        RegionContainer container = WorldGuard.getInstance().getPlatform().getRegionContainer();
        regions = container.get(BukkitAdapter.adapt(loc1.getWorld()));
        if (regions.hasRegion(id + mineSuffix)) {
            region = regions.getRegion(id + mineSuffix);
            return;
        }

        region = new ProtectedCuboidRegion(id + mineSuffix, BlockVector3.at(loc1.x(), loc1.getY(), loc1.getZ()), BlockVector3.at(loc2.x(), loc2.getY(), loc2.getZ()));
        region.setFlag(Flags.BLOCK_BREAK, StateFlag.State.ALLOW);
        regions.addRegion(region);
    }

    private static List<Block> blocksFromTwoPoints(Location loc1, Location loc2) {
        List<Block> blocks = new ArrayList<>();

        int topBlockX = (Math.max(loc1.getBlockX(), loc2.getBlockX()));
        int bottomBlockX = (Math.min(loc1.getBlockX(), loc2.getBlockX()));

        int topBlockY = (Math.max(loc1.getBlockY(), loc2.getBlockY()));
        int bottomBlockY = (Math.min(loc1.getBlockY(), loc2.getBlockY()));

        int topBlockZ = (Math.max(loc1.getBlockZ(), loc2.getBlockZ()));
        int bottomBlockZ = (Math.min(loc1.getBlockZ(), loc2.getBlockZ()));

        for (int x = bottomBlockX; x <= topBlockX; x++) {
            for (int z = bottomBlockZ; z <= topBlockZ; z++) {
                for (int y = bottomBlockY; y <= topBlockY; y++) {
                    Block block = loc1.getWorld().getBlockAt(x, y, z);
                    blocks.add(block);
                }
            }
        }

        return blocks;
    }

    private Location getHologramLocation() {
        World world = loc1.getWorld();
        double x = (loc1.x() + loc2.x()) / 2 + .5;
        double z = (loc1.z() + loc2.z()) / 2 + .5;
        int topBlockY = (Math.max(loc1.getBlockY(), loc2.getBlockY()));
        double y = topBlockY + 4;
        return new Location(world, x, y, z);
    }

    public Location getTeleportPlayerLocation() {
        return getHologramLocation().subtract(0, 2, 0);
    }

    public boolean playerIsInRegion(Player player) {
        Location loc = player.getLocation();
        return region.contains(loc.getBlockX(), loc.getBlockY(), loc.getBlockZ());
    }

    private Material getRandomOre() {
        return oreRandomValueGenerator.generateRandomValue().getOreBlock();
    }
}
