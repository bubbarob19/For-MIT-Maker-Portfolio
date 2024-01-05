#MINING.SK

#OPTIONS

options:
	prefix: &b&lABUNDANT &8•
	pm: &4No permission.

#COMMANDS

command /replacewarzoneitems:
	cooldown: 10 seconds
	cooldown message: {@prefix} &7You must wait 10 seconds to execute this command!
	trigger:
		replaceWarzoneItems(player)
		send "{@prefix} &7You replaced all your warzone items with the correct variants!" to player
		play sound "entity.arrow.hit_player" at pitch 2 to player

command /pickaxe [<integer>]:
	permission: op
	permission message: {@pm}
	trigger:
		if arg-1 is between 1 and 25:
			give player 1 of getPickaxe(arg-1)
			set {_pick} to getPickaxe(arg-1) 
			send "{@prefix} &7You just received %colored displayname of {_pick}%" to player
			play sound "entity.arrow.hit_player" at pitch 2 to player
		else:
			error(player, "You must specify a pickaxe level between 1 and 25!")

command /sword [<integer>]:
	permission: op
	permission message: {@pm}
	trigger:
		if arg-1 is between 1 and 25:
			give player 1 of getSword(arg-1)
			set {_sword} to getSword(arg-1) 
			send "{@prefix} &7You just received %colored displayname of {_sword}%" to player
			play sound "entity.arrow.hit_player" at pitch 2 to player
		else:
			error(player, "You must specify a sword level between 1 and 25!")

command /armor [<text>] [<integer>]:
	permission: op
	permission message: {@pm}
	trigger:
		if arg-1 is "boots" or "helmet" or "chestplate" or "leggings":
			if arg-2 is between 1 and 25:
				give player 1 of getArmor(arg-2, arg-1)
				set {_armor} to getArmor(arg-2, arg-1) 
				send "{@prefix} &7You just received %colored displayname of {_armor}%" to player
				play sound "entity.arrow.hit_player" at pitch 2 to player
			else:
				error(player, "You must specify an armor level between 1 and 25!")
		else:
			error(player, "You must specify a valid armor type!")

#EVENTS

on break:
	"%region at player's location%" contains "warzone"
	player does not have permission "skript.build"
	cancel event
	if event-block is not coal ore or iron ore or lapis ore or gold ore or redstone ore or emerald ore or diamond ore:
		send "{@prefix} &7You can't break that block here!"
		stop
	if {pickaxes::all::*} does not contain player's tool:
		error(player, "You need a special pickaxe from the blacksmith to mine this!")
		stop
	if event-block is iron ore or lapis ore:
		if {pickaxes::iron::*} does not contain player's tool:
			error(player, "You need a stone pickaxe to mine this!")
			stop
	if event-block is gold ore or redstone ore:
		if {pickaxes::gold::*} does not contain player's tool:
			error(player, "You need a iron pickaxe to mine this!")
			stop
	if event-block is diamond ore:
		if {pickaxes::diamonds::*} does not contain player's tool:
			error(player, "You need a diamond pickaxe to mine this!")
			stop
	if event-block is emerald ore:
		if {pickaxes::emeralds::*} does not contain player's tool:
			error(player, "You need a netherite pickaxe to mine this!")
			stop
	cancel drops
	set {_bd} to block data of event-block
	set {_id} to genCode(10)
	set {blocksaves::mining::loc::%{_id}%} to location of event-block
	set {blocksaves::mining::bd::%{_id}%} to blockdata of event-block
	set {_pitch} to a random number between 1.85 and 2
	play sound "entity.arrow.hit_player" at pitch {_pitch} to player
	if player can hold 1 of getEnrichedOre(event-block):
		give player 1 of getEnrichedOre(event-block)
	else:
		drop 1 of getEnrichedOre(event-block) at player's location
		send title "&4&l&nINVENTORY FULL" to player for 3 seconds
	set event-block to bedrock
	wait 30 seconds
	set event-block to {_bd}
	delete {blocksaves::mining::bd::%{_id}%}
	delete {blocksaves::mining::loc::%{_id}%}

on load:
	loop {blocksaves::mining::bd::*}:
		set block at {blocksaves::mining::loc::%loop-index%} to loop-value
	delete {blocksaves::mining::*}
	loop indices of {pickaxes::*}:
		delete {pickaxes::%loop-value%::*}
	delete {pickaxes::*}
	delete {swords::all::*}
	delete {armor::all::*}
	loop 25 times:
		add getPickaxe(loop-number) to {pickaxes::all::*}
		add getSword(loop-number) to {swords::all::*}
		add getArmor(loop-number, "boots") to {armor::all::*}
		add getArmor(loop-number, "chestplate") to {armor::all::*}
		add getArmor(loop-number, "leggings") to {armor::all::*}
		add getArmor(loop-number, "helmet") to {armor::all::*}
		if loop-number is between 21 and 25:
			add getPickaxe(loop-number) to {pickaxes::emeralds::*}
		if loop-number is between 16 and 25:
			add getPickaxe(loop-number) to {pickaxes::diamonds::*}
		if loop-number is between 11 and 25:
			add getPickaxe(loop-number) to {pickaxes::gold::*}
		if loop-number is between 6 and 25:
			add getPickaxe(loop-number) to {pickaxes::iron::*}

on armor change:
	player is not op
	new armor item is not air
	if {armor::all::*} does not contain event-item:
		if player can hold new armor item:
			give player 1 of new armor item
		else:
			drop 1 of new armor item at player's location
		set new armor item to air
		if metadata value "armor" of player is not set:
			error(player, "Only armor made by the blacksmith can protect you!")
		set metadata value "armor" of player to true
		wait 1 second
		clear metadata value "armor" of player

#FUNCTIONS

function getEnrichedOre(ore: block) :: item:
	if {_ore} is coal ore:
		return {item::enrichedcoal}
	else if {_ore} is iron ore:
		return {item::enrichediron}
	else if {_ore} is lapis ore:
		return {item::enrichedlapis}
	else if {_ore} is redstone ore:
		return {item::enrichedredstone}
	else if {_ore} is gold ore:
		return {item::enrichedgold}
	else if {_ore} is emerald ore:
		return {item::enrichedemerald}
	else if {_ore} is diamond ore:
		return {item::enricheddiamond}
	else:
		return barrier named "&4&l&nNULL"

function getPickaxe(level: number) :: item:
	if {_level} > 25:
		return barrier named "&4&l&nNULL"
	set {_tier.type} to {_level}
	if {_level} is between 1 and 5:
		set {_pickaxe} to wooden pickaxe named "&bWooden Pickaxe &8[&f%roman numeral of {_level}%&8]"
	else if {_level} is between 6 and 10:
		set {_pickaxe} to stone pickaxe named "&bStone Pickaxe &8[&f%roman numeral of {_level}%&8]"
		subtract 5 from {_tier.type}
	else if {_level} is between 11 and 15:
		set {_pickaxe} to iron pickaxe named "&bIron Pickaxe &8[&f%roman numeral of {_level}%&8]"
		subtract 10 from {_tier.type}
	else if {_level} is between 16 and 20:
		set {_pickaxe} to diamond pickaxe named "&bDiamond Pickaxe &8[&f%roman numeral of {_level}%&8]"
		subtract 15 from {_tier.type}
	else if {_level} is between 21 and 25:
		set {_pickaxe} to netherite pickaxe named "&bNetherite Pickaxe &8[&f%roman numeral of {_level}%&8]"
		subtract 20 from {_tier.type}
	set {_pickaxe} to unbreakable {_pickaxe}
	set {_pickaxe} to {_pickaxe} with all flags hidden
	set line 1 of {_pickaxe}'s lore to ""
	set line 2 of {_pickaxe}'s lore to "&8• &7Used in the warzone"
	set line 3 of {_pickaxe}'s lore to "&7to mine ores"
	set line 4 of {_pickaxe}'s lore to ""
	set line 5 of {_pickaxe}'s lore to "&8• &7Bring to the blacksmith"
	set line 6 of {_pickaxe}'s lore to "&7to upgrade"
	if {_tier.type} is 1:
		return {_pickaxe}
	else:
		set {_efflvl} to ({_tier.type} - 1)
		enchant {_pickaxe} with "efficiency %{_efflvl}%" parsed as an enchantment type
		set line 7 of {_pickaxe}'s lore to ""
		set line 8 of {_pickaxe}'s lore to "&7Efficiency %roman numeral of ({_tier.type} - 1)%"
		return {_pickaxe}

function getGearLevel(gear: item) :: number:
	if {armor::all::*} contains {_gear}:
		set {_name} to displayname of {_gear}
		replace all "&b", "Netherite", "Diamond", "Iron", "Stone", "Wooden", "Leather", "Chainmail", " Pickaxe ", " Sword ", " Leggings ", " Chestplate ", " Helmet ", " Boots ", "&8[&f" and "&8]" in {_name} with ""
		return (arabic number of {_name}) 
	else if {swords::all::*} contains {_gear}:
		set {_name} to displayname of {_gear}
		replace all "&b", "Netherite", "Diamond", "Iron", "Stone", "Wooden", "Leather", "Chainmail", " Pickaxe ", " Sword ", " Leggings ", " Chestplate ", " Helmet ", " Boots ", "&8[&f" and "&8]" in {_name} with ""
		return (arabic number of {_name}) 
	else if {pickaxes::all::*} contains {_gear}:
		set {_name} to displayname of {_gear}
		replace all "&b", "Netherite", "Diamond", "Iron", "Stone", "Wooden", "Leather", "Chainmail", " Pickaxe ", " Sword ", " Leggings ", " Chestplate ", " Helmet ", " Boots ", "&8[&f" and "&8]" in {_name} with ""
		return (arabic number of {_name}) 
	else:
		return 0

function getSword(level: number) :: item:
	if {_level} > 25:
		return barrier named "&4&l&nNULL"
	set {_tier.type} to {_level}
	if {_level} is between 1 and 5:
		set {_sword} to wooden sword named "&bWooden Sword &8[&f%roman numeral of {_level}%&8]"
	else if {_level} is between 6 and 10:
		set {_sword} to stone sword named "&bStone Sword &8[&f%roman numeral of {_level}%&8]"
		subtract 5 from {_tier.type}
	else if {_level} is between 11 and 15:
		set {_sword} to iron sword named "&bIron Sword &8[&f%roman numeral of {_level}%&8]"
		subtract 10 from {_tier.type}
	else if {_level} is between 16 and 20:
		set {_sword} to diamond sword named "&bDiamond Sword &8[&f%roman numeral of {_level}%&8]"
		subtract 15 from {_tier.type}
	else if {_level} is between 21 and 25:
		set {_sword} to netherite sword named "&bNetherite Sword &8[&f%roman numeral of {_level}%&8]"
		subtract 20 from {_tier.type}
	set {_sword} to unbreakable {_sword}
	set {_sword} to {_sword} with all flags hidden
	set line 1 of {_sword}'s lore to ""
	set line 2 of {_sword}'s lore to "&8• &7Used in the warzone"
	set line 3 of {_sword}'s lore to "&7to fight other players"
	set line 4 of {_sword}'s lore to ""
	set line 5 of {_sword}'s lore to "&8• &7Bring to the blacksmith"
	set line 6 of {_sword}'s lore to "&7to upgrade"
	if {_tier.type} is 1:
		return {_sword}
	else:
		set {_efflvl} to ({_tier.type} - 1)
		enchant {_sword} with "sharpness %{_efflvl}%" parsed as an enchantment type
		set line 7 of {_sword}'s lore to ""
		set line 8 of {_sword}'s lore to "&7Sharpness %roman numeral of ({_tier.type} - 1)%"
		return {_sword}

function getArmor(level: number, type: text) :: item:
	if {_level} > 25:
		return barrier named "&4&l&nNULL"
	set {_tier.type} to {_level}	
	if {_level} is between 1 and 5:
		if {_type} is "helmet":
			set {_armor} to leather cap named "&bLeather Helmet &8[&f%roman numeral of {_level}%&8]"
		else if {_type} is "chestplate":
			set {_armor} to leather tunic named "&bLeather Chestplate &8[&f%roman numeral of {_level}%&8]"
		else if {_type} is "leggings":
			set {_armor} to leather leggings named "&bLeather Leggings &8[&f%roman numeral of {_level}%&8]"
		else if {_type} is "boots":
			set {_armor} to leather boots named "&bLeather Boots &8[&f%roman numeral of {_level}%&8]"
	else if {_level} is between 6 and 10:
		if {_type} is "helmet":
			set {_armor} to chain helmet named "&bChainmail Helmet &8[&f%roman numeral of {_level}%&8]"
		else if {_type} is "chestplate":
			set {_armor} to chain chestplate named "&bChainmail Chestplate &8[&f%roman numeral of {_level}%&8]"
		else if {_type} is "leggings":
			set {_armor} to chain leggings named "&bChainmail Leggings &8[&f%roman numeral of {_level}%&8]"
		else if {_type} is "boots":
			set {_armor} to chain boots named "&bChainmail Boots &8[&f%roman numeral of {_level}%&8]"
		subtract 5 from {_tier.type}
	else if {_level} is between 11 and 15:
		if {_type} is "helmet":
			set {_armor} to iron helmet named "&bIron Helmet &8[&f%roman numeral of {_level}%&8]"
		else if {_type} is "chestplate":
			set {_armor} to iron chestplate named "&bIron Chestplate &8[&f%roman numeral of {_level}%&8]"
		else if {_type} is "leggings":
			set {_armor} to iron leggings named "&bIron Leggings &8[&f%roman numeral of {_level}%&8]"
		else if {_type} is "boots":
			set {_armor} to iron boots named "&bIron Boots &8[&f%roman numeral of {_level}%&8]"
		subtract 10 from {_tier.type}
	else if {_level} is between 16 and 20:
		if {_type} is "helmet":
			set {_armor} to diamond helmet named "&bDiamond Helmet &8[&f%roman numeral of {_level}%&8]"
		else if {_type} is "chestplate":
			set {_armor} to diamond chestplate named "&bDiamond Chestplate &8[&f%roman numeral of {_level}%&8]"
		else if {_type} is "leggings":
			set {_armor} to diamond leggings named "&bDiamond Leggings &8[&f%roman numeral of {_level}%&8]"
		else if {_type} is "boots":
			set {_armor} to diamond boots named "&bDiamond Boots &8[&f%roman numeral of {_level}%&8]"
		subtract 15 from {_tier.type}
	else if {_level} is between 21 and 25:
		if {_type} is "helmet":
			set {_armor} to netherite helmet named "&bNetherite Helmet &8[&f%roman numeral of {_level}%&8]"
		else if {_type} is "chestplate":
			set {_armor} to netherite chestplate named "&bNetherite Chestplate &8[&f%roman numeral of {_level}%&8]"
		else if {_type} is "leggings":
			set {_armor} to netherite leggings named "&bNetherite Leggings &8[&f%roman numeral of {_level}%&8]"
		else if {_type} is "boots":
			set {_armor} to netherite boots named "&bNetherite Boots &8[&f%roman numeral of {_level}%&8]"
		subtract 20 from {_tier.type}
	set {_armor} to unbreakable {_armor}
	set {_armor} to {_armor} with all flags hidden
	set line 1 of {_armor}'s lore to ""
	set line 2 of {_armor}'s lore to "&8• &7Used in the warzone"
	set line 3 of {_armor}'s lore to "&7to protect yourself"
	set line 4 of {_armor}'s lore to ""
	set line 5 of {_armor}'s lore to "&8• &7Bring to the blacksmith"
	set line 6 of {_armor}'s lore to "&7to upgrade"
	if {_tier.type} is 1:
		return {_armor}
	else:
		set {_efflvl} to ({_tier.type} - 1)
		enchant {_armor} with "protection %{_efflvl}%" parsed as an enchantment type
		set line 7 of {_armor}'s lore to ""
		set line 8 of {_armor}'s lore to "&7Protection %roman numeral of ({_tier.type} - 1)%"
		return {_armor}

function replaceWarzoneItems(p: player):
	loop {_p}'s inventory:
		if name of loop-value contains " Pickaxe &8[" or " Sword &8[" or " Helmet &8[" or " Leggings &8[" or " Chestplate &8[" or " Boots &8[":
			if {pickaxes::all::*} does not contain loop-value:
				if {swords::all::*} does not contain loop-value:
					if {armor::all::*} does not contain loop-value:
						set {_name} to displayname of loop-value
						if {_name} contains "Pickaxe":
							replace all "&bWooden ", "&bStone ", "&bIron ", "&bDiamond ", "&bNetherite ", "Pickaxe &8[", "&f" and "&8]" in {_name} with ""
							set {_tier} to arabic number of {_name}
							set loop-value to (item amount of loop-value) of getPickaxe({_tier})
						else if {_name} contains "Sword":
							replace all "&bWooden ", "&bStone ", "&bIron ", "&bDiamond ", "&bNetherite ", "Sword &8[", "&f" and "&8]" in {_name} with ""
							set {_tier} to arabic number of {_name}
							set loop-value to (item amount of loop-value) of getSword({_tier})
						else if {_name} contains "Helmet":
							replace all "&bLeather ", "&bChainmail ", "&bIron ", "&bDiamond ", "&bNetherite ", "Helmet &8[", "&f" and "&8]" in {_name} with ""
							set {_tier} to arabic number of {_name}
							set loop-value to (item amount of loop-value) of getArmor({_tier}, "helmet")
						else if {_name} contains "Chestplate":
							replace all "&bLeather ", "&bChainmail ", "&bIron ", "&bDiamond ", "&bNetherite ", "Chestplate &8[", "&f" and "&8]" in {_name} with ""
							set {_tier} to arabic number of {_name}
							set loop-value to (item amount of loop-value) of getArmor({_tier}, "chestplate")
						else if {_name} contains "Leggings":
							replace all "&bLeather ", "&bChainmail ", "&bIron ", "&bDiamond ", "&bNetherite ", "Leggings &8[", "&f" and "&8]" in {_name} with ""
							set {_tier} to arabic number of {_name}
							set loop-value to (item amount of loop-value) of getArmor({_tier}, "leggings")
						else if {_name} contains "Boots":
							replace all "&bLeather ", "&bChainmail ", "&bIron ", "&bDiamond ", "&bNetherite ", "Boots &8[", "&f" and "&8]" in {_name} with ""
							set {_tier} to arabic number of {_name}
							set loop-value to (item amount of loop-value) of getArmor({_tier}, "boots")
	loop items in {_p}'s enderchest:
		if name of loop-value contains " Pickaxe &8[" or " Sword &8[" or " Helmet &8[" or " Leggings &8[" or " Chestplate &8[" or " Boots &8[":
			if {pickaxes::all::*} does not contain loop-value:
				if {swords::all::*} does not contain loop-value:
					if {armor::all::*} does not contain loop-value:
						set {_name} to displayname of loop-value
						if {_name} contains "Pickaxe":
							replace all "&bWooden ", "&bStone ", "&bIron ", "&bDiamond ", "&bNetherite ", "Pickaxe &8[", "&f" and "&8]" in {_name} with ""
							set {_tier} to arabic number of {_name}
							set loop-value to (item amount of loop-value) of getPickaxe({_tier})
						else if {_name} contains "Sword":
							replace all "&bWooden ", "&bStone ", "&bIron ", "&bDiamond ", "&bNetherite ", "Sword &8[", "&f" and "&8]" in {_name} with ""
							set {_tier} to arabic number of {_name}
							set loop-value to (item amount of loop-value) of getSword({_tier})
						else if {_name} contains "Helmet":
							replace all "&bLeather ", "&bChainmail ", "&bIron ", "&bDiamond ", "&bNetherite ", "Helmet &8[", "&f" and "&8]" in {_name} with ""
							set {_tier} to arabic number of {_name}
							set loop-value to (item amount of loop-value) of getArmor({_tier}, "helmet")
						else if {_name} contains "Chestplate":
							replace all "&bLeather ", "&bChainmail ", "&bIron ", "&bDiamond ", "&bNetherite ", "Chestplate &8[", "&f" and "&8]" in {_name} with ""
							set {_tier} to arabic number of {_name}
							set loop-value to (item amount of loop-value) of getArmor({_tier}, "chestplate")
						else if {_name} contains "Leggings":
							replace all "&bLeather ", "&bChainmail ", "&bIron ", "&bDiamond ", "&bNetherite ", "Leggings &8[", "&f" and "&8]" in {_name} with ""
							set {_tier} to arabic number of {_name}
							set loop-value to (item amount of loop-value) of getArmor({_tier}, "leggings")
						else if {_name} contains "Boots":
							replace all "&bLeather ", "&bChainmail ", "&bIron ", "&bDiamond ", "&bNetherite ", "Boots &8[", "&f" and "&8]" in {_name} with ""
							set {_tier} to arabic number of {_name}
							set loop-value to (item amount of loop-value) of getArmor({_tier}, "boots")