#HARVESTING.SK

#OPTIONS

options:
	prefix: &b&lABUNDANT &8•
	pm: &4No permission.

#EVENTS

on load:
	set {axes::*} to {item::dullaxe}, {item::heavyaxe}, {item::mediocreaxe}, {item::shinyaxe}, {item::axeofdeath} and {item::goldenaxe}
	loop {blocksaves::farming::bd::*}:
		set block at {blocksaves::farming::loc::%loop-index%} to loop-value
	delete {blocksaves::farming::bd::*}
	delete {blocksaves::farming::loc::*}

on place of oak bark:
	if event-item = {item::woodbundle}:
		cancel event

on place of oak log:
	if event-item = {item::woodpile}:
		cancel event

on npc right click:
	if name of citizen event-number is "&b&l&nHARVESTER":
		metadata value "talkingtonpc" of player is not set
		if {harvester::claimed::%player's uuid%} is not set:
			set metadata value "talkingtonpc" of player to true
			send "%nl%&b&lHARVESTER &8• &fHey there %player%&f, I see you have discovered the beautiful nature island!%nl%" to player
			play sound "entity.villager.yes" at pitch 0.7 to player
			wait 5 seconds
			send "%nl%&b&lHARVESTER &8• &fMany people don't take advantage of the amazing resources here but they really should! You can compost crops and wood into valuable multipliers!%nl%" to player
			play sound "entity.villager.yes" at pitch 0.7 to player
			wait 5 seconds
			if player can hold 1 of {item::dullaxe}:
				send "%nl%&b&lHARVESTER &8• &fSpeaking of wood, my buddy Fred down in Hansworth gave me his dull axe the other day. It's not much use to me, so I'll let you have it!%nl%" to player
				play sound "entity.villager.yes" at pitch 0.7 to player
				give player 1 of {item::dullaxe}
				wait 5 seconds
				send "%nl%&b&lHARVESTER &8• &fObviously this dull axe isn't a great long term solution, so whenever you feel that you need an upgrade make sure to bring it by me! All I charge to upgrade are some natural resources!%nl%" to player
				play sound "entity.villager.yes" at pitch 0.7 to player
				wait 5 seconds
				send "%nl%&b&lHARVESTER &8• &fI'll see you around, %player%&f. Come talk to me if you need anything!%nl%"
				play sound "entity.villager.yes" at pitch 0.7 to player
				set {harvester::claimed::%player's uuid%} to true
			else:
				send "%nl%&b&lHARVESTER &8• &fOh no! I have a dull axe I'd like to give you, but you dont seem to have any room to carry it! Come back when you have more space!%nl%" to player
				play sound "entity.villager.no" at pitch 0.7 to player
			clear metadata value "talkingtonpc" of player
		else:
			play sound "entity.chicken.egg" at pitch 0 to player
			harvesterMenu(player)

on break:
	set {_bd} to blockdata of event-block
	"%region at player's location%" contains "farming"
	player does not have permission "skript.build"
	if event-block is not oak bark or oak log or carrot plant or potato plant or wheat plant or beetroot plant:
		send "{@prefix} &7You can't break that block here!"
		cancel event
		stop
	else if "%region at location of event-block%" contains "windmill":
		send "{@prefix} &7You can't break that block here!"
		cancel event
		stop
	cancel drops
	set {_id} to genCode(10)
	if event-block is wheat plant:
		farmItem(player, {item::wheat})
	else if event-block is carrot plant:
		farmItem(player, {item::carrot})
	else if event-block is potato plant:
		farmItem(player, {item::potato})
	else if event-block is beetroot plant:
		farmItem(player, {item::beetroot})
	else if event-block is oak log:
		if {axes::*} contains player's tool:
			if player can hold 1 of {item::woodchips}:
				give player 1 of {item::woodchips}
			else:
				drop 1 of {item::woodchips} at location of event-block
			set {_sound} to a random number between 1.85 and 2
			play sound "entity.arrow.hit_player" at pitch {_sound} to player
		else:
			error(player, "You must use an axe from the harvester! (/harvester)")
			cancel event
			stop
	else if event-block is oak bark:
		if {axes::*} contains player's tool:
			if player can hold 1 of {item::woodchips}:
				give player 1 of {item::woodchips}
			else:
				drop 1 of {item::woodchips} at location of event-block
			set {_sound} to a random number between 1.85 and 2
			play sound "entity.arrow.hit_player" at pitch {_sound} to player
		else:
			error(player, "You must use an axe from the harvester! (/harvester)")
			cancel event
			stop
	set {blocksaves::farming::bd::%{_id}%} to {_bd}
	set {blocksaves::farming::loc::%{_id}%} to location of event-block
	if block above event-block is spruce slab:
		set {_s.id} to genCode(10)
		set {blocksaves::farming::bd::%{_s.id}%} to blockdata of block above event-block
		set {blocksaves::farming::loc::%{_s.id}%} to location of block above event-block
		set block above event-block to air
	wait 30 seconds
	set event-block to {_bd}
	delete {blocksaves::farming::bd::%{_id}%}
	delete {blocksaves::farming::loc::%{_id}%}
	if {_s.id} is set:
		set block above event-block to {blocksaves::farming::bd::%{_s.id}%}
		delete {blocksaves::farming::bd::%{_s.id}%}
		delete {blocksaves::farming::loc::%{_s.id}%}

#FUNCTIONS

function farmItem(p: player, i: item):
	give {_p} 1 of {_i}
	if {_p} cannot hold 1 of {_i}:
		send title "&4&l&nERROR" with subtitle "&cYour inventory is full!" to {_p}
		play sound "entity.villager.no" to {_p}

function harvesterMenu(p: player):
	create a gui with virtual chest inventory with size 4 named "Harvester":
		set {_hay.format} to {item::compressedwheat}
		make gui slot (integers between 0 and 35) with light gray stained glass pane named "&1"
		make gui slot (integers between 27 and 35) with black stained glass pane named "&1"
		make gui slot 35 with barrier named "&4Close Menu":
			close {_p}'s inventory
			play sound "entity.chicken.egg" at pitch 0 to player
		make gui slot 10 with {_hay.format} named "&fCompress Crops" with lore "", "&8• &7Click &bhere &7to" and "&7compress your crops!":
			play sound "entity.chicken.egg" at pitch 0 to player
			compressCropsMenu({_p})
		make gui slot 12 with oak bark named "&fCompress Wood" with lore "", "&8• &7Click &bhere &7to" and "&7compress your wood!":
			play sound "entity.chicken.egg" at pitch 0 to player
			compressWoodMenu({_p})
		make gui slot 14 with wooden axe with all flags hidden named "&fUpgrade Axe" with lore "", "&8• &7Click &bhere &7to upgrade" and "&7or purchase an axe!":
			play sound "entity.chicken.egg" at pitch 0 to player
			upgradeAxeMenu({_p})
		make gui slot 16 with composter named "&fCompost" with lore "", "&8• &7Click &bhere &7to compost your" and "&7natural resources into multipliers!":
			play sound "entity.chicken.egg" at pitch 0 to player
			compostingMenu({_p})
	open the last gui to {_p}

function compostingMenu(p: player):
	set {_u} to uuid of {_p}
	create a gui with virtual chest inventory with size 4 named "Compost":
		make gui slot (integers between 0 and 35) with light gray stained glass pane named "&1"
		make gui slot (integers between 27 and 35) with black stained glass pane named "&1"
		make gui slot 35 with barrier named "&4Back":
			harvesterMenu({_p})
			play sound "entity.chicken.egg" at pitch 0 to player
		make gui slot 13 with composter named "&fCompost your crops / wood" with lore "", "&8• &7Compost your materials into", "&7a &b+0.05 Multiplier Voucher", "", "&fCost:", "&8• &7x25 Compressed Wheat", "&8• &7x25 Compressed Carrots", "&8• &7x25 Compressed Potatoes", "&8• &7x25 Compressed Beetroots", "&8• &7x1 Wood Bundle", "" and "&8• &7Click &bhere &7to compost!":
			if {_p} has (25 of {item::compressedwheat}), (25 of {item::compressedcarrots}), (25 of {item::compressedpotatoes}), (25 of {item::compressedbeetroots}) and (1 of {item::woodbundle}):
				if {_p} can hold 1 of multiplierVoucher(0.05):
					remove (25 of {item::compressedwheat}), (25 of {item::compressedcarrots}), (25 of {item::compressedpotatoes}), (25 of {item::compressedbeetroots}) and (1 of {item::woodbundle}) from {_p}
					give {_p} 1 of multiplierVoucher(0.05)
					send "{@prefix} &7You composted nature materials into a &b+0.05 Multiplier Voucher&7!" to {_p}
					play sound "entity.arrow.hit_player" at pitch 2 to {_p}
				else:
					error({_p}, "You do not have enough inventory space for this!")
			else:
				error({_p}, "Insufficient resources")
	open the last gui to {_p}

function upgradeAxeMenu(p: player):
	set {_u} to uuid of {_p}
	create a gui with id "upgradeaxemenu-%{_u}%" with virtual chest inventory with size 4 named "Compress Wood":
		run on gui close:
			delete gui with id "upgradeaxemenu-%{_u}%"
		make gui slot (integers between 0 and 35) with light gray stained glass pane named "&1"
		make gui slot (integers between 27 and 35) with black stained glass pane named "&1"
		make gui slot 35 with barrier named "&4Back":
			harvesterMenu({_p})
			play sound "entity.chicken.egg" at pitch 0 to player
		make gui slot 10 with wooden axe with all flags hidden named "&fDull Axe" with lore "", "&8• &7Is this a club or an axe?", "", "&fCost: &d♦100", "" and "&8• &7Click &bhere &7to purchase":
			if {crystals::%{_u}%} >= 100:
				if {_p} can hold 1 of {item::dullaxe}:
					subtract 100 from {crystals::%{_u}%}
					give {_p} 1 of {item::dullaxe}
					send "{@prefix} &7You purchased a new axe!" to {_p}
					play sound "entity.arrow.hit_player" at pitch 2 to {_p}
				else:
					error({_p}, "You do not have enough inventory space for this!")
			else:
				error({_p}, "Insufficient funds")
		formatUpgradeAxeSlot({_p}, 12, 2, {item::woodpile}, 500, {item::wheat}, {item::heavyaxe}, {item::dullaxe})
		formatUpgradeAxeSlot({_p}, 13, 1, {item::woodbundle}, 12, {item::compressedwheat}, {item::mediocreaxe}, {item::heavyaxe})
		formatUpgradeAxeSlot({_p}, 14, 2, {item::woodbundle}, 25, {item::compressedcarrots}, {item::shinyaxe}, {item::mediocreaxe})
		formatUpgradeAxeSlot({_p}, 15, 5, {item::woodbundle}, 50, {item::compressedpotatoes}, {item::axeofdeath}, {item::shinyaxe})
		formatUpgradeAxeSlot({_p}, 16, 15, {item::woodbundle}, 100, {item::compressedbeetroots}, {item::goldenaxe}, {item::axeofdeath})
	open the last gui to {_p}

function formatUpgradeAxeSlot(p: player, slot: number, woodcost: number, woodtype: item, cropcost: number, croptype: item, axe: item, previousaxe: item):
	set {_u} to uuid of {_p}
	set {_axe.format} to {_axe}
	set line getLoreLines({_axe.format}) + 1 of {_axe.format}'s lore to ""
	set line getLoreLines({_axe.format}) + 1 of {_axe.format}'s lore to "&fCost:"
	set line getLoreLines({_axe.format}) + 1 of {_axe.format}'s lore to "&8• &7%displayname of {_previousaxe}%"
	set line getLoreLines({_axe.format}) + 1 of {_axe.format}'s lore to "&8• &7x%{_woodcost}% &7%uncolored displayname of {_woodtype}%"
	set line getLoreLines({_axe.format}) + 1 of {_axe.format}'s lore to "&8• &7x%{_cropcost}% &7%uncolored displayname of {_croptype}%"
	set line getLoreLines({_axe.format}) + 1 of {_axe.format}'s lore to ""
	set line getLoreLines({_axe.format}) + 1 of {_axe.format}'s lore to "&8• &7Click &bhere &7to upgrade"
	edit gui with id "upgradeaxemenu-%{_u}%":
		make gui slot {_slot} with {_axe.format}:
			if {_p} has {_cropcost} of {_croptype}:
				if {_p} has {_woodcost} of {_woodtype}:
					if {_p} has {_previousaxe}:
						remove 1 of {_previousaxe} from {_p}
						remove {_cropcost} of {_croptype} from {_p}
						remove {_woodcost} of {_woodtype} from {_p}
						send "{@prefix} &7You upgraded your axe to the &f%displayname of {_axe}%&7!" to {_p}
						play sound "entity.arrow.hit_player" at pitch 2 to player
						wait 1 tick
						give {_p} 1 of {_axe}
					else:
						error({_p}, "You lack the previous axe!")
				else:
					error({_p}, "Insufficient resources")
			else:
				error({_p}, "Insufficient resources")

function compressWoodMenu(p: player):
	set {_u} to uuid of {_p}
	create a gui with virtual chest inventory with size 4 named "Compress Wood":
		make gui slot (integers between 0 and 35) with light gray stained glass pane named "&1"
		make gui slot (integers between 27 and 35) with black stained glass pane named "&1"
		make gui slot 35 with barrier named "&4Back":
			harvesterMenu({_p})
			play sound "entity.chicken.egg" at pitch 0 to player
		make gui slot 11 with oak plank named "&fWood Pile" with lore "", "&8• &7Made from wood chips", "", "&fRequired Materials:", "&8• &7x32 Wood Chips", "" and "&8• &7Click &bhere &7to compress":
			if {_p} has 32 of {item::woodchips}:
				if {_p} can hold 1 of {item::woodpile}:
					remove 32 of {item::woodchips} from {_p}'s inventory
					give {_p} 1 of  {item::woodpile}
					play sound "entity.arrow.hit_player" at pitch 1.4 to {_p}
				else:
					error({_p}, "You do not have enough inventory space for this!")
			else:
				error({_p}, "Insufficient Resources")
		make gui slot 15 with oak bark named "&fWood Bundle" with lore "", "&8• &7A giant bundle of wood piles", "", "&fRequired Materials:", "&8• &7x10 Wood Pile", "" and "&8• &7Click &bhere &7to compress":
			if {_p} has 10 of {item::woodpile}:
				if {_p} can hold 1 of {item::woodbundle}:
					remove 10 of {item::woodpile} from {_p}'s inventory
					give {_p} 1 of  {item::woodbundle}
					play sound "entity.arrow.hit_player" at pitch 1.4 to {_p}
				else:
					error({_p}, "You do not have enough inventory space for this!")
			else:
				error({_p}, "Insufficient Resources")
	open the last gui to {_p}

function compressCropsMenu(p: player):
	set {_u} to uuid of {_p}
	create a gui with id "compresscrops-%{_u}%" with virtual chest inventory with size 4 named "Compress Crops":
		run on gui close:
			delete gui with id "compresscrops-%{_u}%"
		make gui slot (integers between 0 and 35) with light gray stained glass pane named "&1"
		make gui slot (integers between 27 and 35) with black stained glass pane named "&1"
		make gui slot 35 with barrier named "&4Back":
			harvesterMenu({_p})
			play sound "entity.chicken.egg" at pitch 0 to player
		formatCompressCropMenu({_p}, 10, {item::wheat}, {item::compressedwheat})
		formatCompressCropMenu({_p}, 12, {item::carrot}, {item::compressedcarrots})
		formatCompressCropMenu({_p}, 14, {item::potato}, {item::compressedpotatoes})
		formatCompressCropMenu({_p}, 16, {item::beetroot}, {item::compressedbeetroots})
	open the last gui to {_p}

function formatCompressCropMenu(p: player, slot: number, crop: item, compressedcrop: item):
	set {_u} to uuid of {_p}
	set {_format.crop} to {_compressedcrop}
	set line getLoreLines({_format.crop}) + 1 of {_format.crop}'s lore to ""
	set line getLoreLines({_format.crop}) + 1 of {_format.crop}'s lore to "&fRequired Materials:"
	set line getLoreLines({_format.crop}) + 1 of {_format.crop}'s lore to "&8• &7x100 &7%uncolored displayname of {_crop}%"
	set line getLoreLines({_format.crop}) + 1 of {_format.crop}'s lore to ""
	set line getLoreLines({_format.crop}) + 1 of {_format.crop}'s lore to "&8• &7Click &bhere &7to compress"
	edit gui with id "compresscrops-%{_u}%":
		make gui slot {_slot} with {_format.crop}:
			if {_p} has 100 of {_crop}:
				remove 100 of {_crop} from {_p}'s inventory
				play sound "entity.arrow.hit_player" at pitch 1.2 to {_p}
				wait 1 tick
				give {_p} 1 of {_compressedcrop}
			else:
				error({_p}, "Insufficient resources")