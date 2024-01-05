#CRATES.SK

#OPTIONS

options:
	prefix: &b&lABUNDANT &8•
	daily: &f&lDAILY CRATE &8•
	rare: &9&lRARE CRATE &8•
	epik: &5&lEPIK CRATE &8•
	exotic: &2&lEXOTIC CRATE &8•
	legendary: &6&lLEGENDARY CRATE &8•
	mythic: &e&lMYTHIC CRATE &8•
	abundant: &b&lABUNDANT CRATE &8•

#COMMANDS

command /clearcratemeta:
	trigger:
		clear metadata value "crate-opening" of player

#EVENTS

on right click:
	if "%event-block%" contains "shulker box":
		if event-block is in region "crates" parsed as a region:
			cancel event
			metadata value "crate-opening" of player is not set
			if player's tool is {item::%getRarity(event-block)%key}:
				set {_amt} to item amount of player's tool
				set player's tool to ({_amt} - 1) of player's tool
				openCrate(player, getRarity(event-block), location of event-block)
			else:
				error(player, "You are not using the correct key to open this crate!")

on left click:
	"%event-block%" contains "shulker box"
	event-block is in region "crates" parsed as a region
	cancel event
	metadata value "crate-opening" of player is not set
	viewCrate(player, getRarity(event-block))

#FUNCTIONS

function winCrateReward(p: player, msg: text):
	send "%{_msg}%" to {_p}
	play sound "entity.firework_rocket.launch" to {_p}
	wait 25 ticks
	play sound "entity.firework_rocket.blast" to {_p}
	clear metadata value "crate-opening" of {_p}

function openCrate(p: player, rarity: text, location: location):
	set {_u} to uuid of {_p}
	set {_n} to a random integer between 1 and 100
	play song file "plugins/FunkySk/cratesound.nbs" to {_p}
	set metadata value "crate-opening" of {_p} to true
	wait 3.5 seconds
	if {_rarity} = "daily":
		if {_n} is between 1 and 30:
			add 15000 to {balance::%{_u}%}
			winCrateReward({_p}, "{@daily} &7You won &a$15K!")
		else if {_n} is between 31 and 60:
			add 25 to {crystals::%{_u}%}
			winCrateReward({_p}, "{@daily} &7You won &d♦25!")
		else if {_n} is between 61 and 90:
			give {_p} 1 of {generator::block::2}
			winCrateReward({_p}, "{@daily} &7You won a &bPumpkin Generator!")
		else:
			give {_p} 1 of {item::rarekey}
			winCrateReward({_p}, "{@daily} &7You won a &9&lRARE KEY!")
	else if {_rarity} = "rare":
		if {_n} is between 1 and 30:
			add 50000 to {balance::%{_u}%}
			winCrateReward({_p}, "{@rare} &7You won &a$50K!")
		else if {_n} is between 31 and 60:
			add 50 to {crystals::%{_u}%}
			winCrateReward({_p}, "{@rare} &7You won &d♦50!")
		else if {_n} is between 61 and 80:
			give {_p} 1 of {generator::block::3}
			winCrateReward({_p}, "{@rare} &7You won a &bMelon Generator!")
		else if {_n} is between 81 and 90:
			give {_p} 1 of {generator::block::4}
			winCrateReward({_p}, "{@rare} &7You won a &bStone Generator!")
		else:
			give {_p} 1 of {item::epikkey}
			winCrateReward({_p}, "{@rare} &7You won an &5&lEPIK KEY!")
	else if {_rarity} = "epik":
		if {_n} is between 1 and 30:
			add 150000 to {balance::%{_u}%}
			winCrateReward({_p}, "{@epik} &7You won &a$150K!")
		else if {_n} is between 31 and 50:
			add 100 to {crystals::%{_u}%}
			winCrateReward({_p}, "{@epik} &7You won &d♦100!")
		else if {_n} is between 51 and 70:
			give {_p} 1 of {generator::block::5}
			winCrateReward({_p}, "{@epik} &7You won a &bCoal Generator!")
		else if {_n} is between 71 and 90:
			give {_p} 1 of {generator::block::6}
			winCrateReward({_p}, "{@epik} &7You won a &bCopper Generator!")
		else:
			give {_p} 1 of {item::exotickey}
			winCrateReward({_p}, "{@epik} &7You won an &2&lEXOTIC KEY!")
	else if {_rarity} = "exotic":
		if {_n} is between 1 and 30:
			add 1000000 to {balance::%{_u}%}
			winCrateReward({_p}, "{@exotic} &7You won &a$1M!")
		else if {_n} is between 31 and 50:
			add 250 to {crystals::%{_u}%}
			winCrateReward({_p}, "{@exotic} &7You won &d♦250!")
		else if {_n} is between 51 and 60:
			give {_p} 1 of {generator::block::7}
			winCrateReward({_p}, "{@exotic} &7You won an &bIron Generator!")
		else if {_n} is between 61 and 75:
			give {_p} 1 of genSlotVoucher(1)
			winCrateReward({_p}, "{@exotic} &7You won a &b+1 Gen Slot Voucher!")
		else if {_n} is between 76 and 90:
			give {_p} 1 of hopperSlotVoucher(1)
			winCrateReward({_p}, "{@exotic} &7You won a &b+1 Hopper Slot Voucher!")
		else:
			give {_p} 1 of {item::legendarykey}
			winCrateReward({_p}, "{@exotic} &7You won a &6&lLEGENDARY KEY!")
	else if {_rarity} = "legendary":
		if {_n} is between 1 and 30:
			add 5000000 to {balance::%{_u}%}
			winCrateReward({_p}, "{@legendary} &7You won &a$5M!")
		else if {_n} is between 31 and 50:
			add 500 to {crystals::%{_u}%}
			winCrateReward({_p}, "{@legendary} &7You won &d♦500!")
		else if {_n} is between 51 and 70:
			give {_p} 1 of {generator::block::8}
			winCrateReward({_p}, "{@legendary} &7You won an &bAluminum Generator!")
		else if {_n} is between 71 and 80:
			give {_p} 1 of genSlotVoucher(2)
			winCrateReward({_p}, "{@legendary} &7You won a &b+2 Gen Slot Voucher!")
		else if {_n} is between 81 and 90:
			give {_p} 1 of hopperSlotVoucher(2)
			winCrateReward({_p}, "{@legendary} &7You won a &b+2 Hopper Slot Voucher!")
		else:
			give {_p} 1 of {item::mythickey}
			winCrateReward({_p}, "{@legendary} &7You won a &e&lMYTHIC KEY!")
	else if {_rarity} = "mythic":
		if {_n} is between 1 and 30:
			add 50000000 to {balance::%{_u}%}
			winCrateReward({_p}, "{@mythic} &7You won &a$50M!")
		else if {_n} is between 31 and 50:
			add 1000 to {crystals::%{_u}%}
			winCrateReward({_p}, "{@mythic} &7You won &d♦1000!")
		else if {_n} is between 51 and 65:
			give {_p} 1 of {generator::block::10}
			winCrateReward({_p}, "{@mythic} &7You won a &bQuartz Generator!")
		else if {_n} is between 66 and 80:
			give {_p} 1 of genSlotVoucher(5)
			winCrateReward({_p}, "{@mythic} &7You won a &b+5 Gen Slot Voucher!")
		else if {_n} is between 81 and 95:
			give {_p} 1 of hopperSlotVoucher(5)
			winCrateReward({_p}, "{@mythic} &7You won a &b+5 Hopper Slot Voucher!")
		else:
			give {_p} 1 of {item::abundantkey}
			winCrateReward({_p}, "{@mythic} &7You won an &b&lABUNDANT KEY!")
	else if {_rarity} = "abundant":
		if {_n} is between 1 and 30:
			give {_p} 1 of genSlotVoucher(15)
			winCrateReward({_p}, "{@abundant} &7You won a &b+15 Gen Slot Voucher!")
		else if {_n} is between 31 and 60:
			give {_p} 1 of hopperSlotVoucher(15)
			winCrateReward({_p}, "{@abundant} &7You won a &b+15 Hopper Slot Voucher!")
		else if {_n} is between 61 and 90:
			give {_p} 1 of {generator::block::15}
			winCrateReward({_p}, "{@abundant} &7You won a &bCobalt Generator!")
		else if {_n} is between 91 and 99:
			give {_p} 2 of {item::abundantkey}
			winCrateReward({_p}, "{@abundant} &7You won &fx2 &b&lABUNDANT KEY!")
		else:
			give {_p} 1 of {item::abundantrankvoucher}
			send "%nl%{@prefix} &f%{_p}% &7just won a seasonal <##EA1515>&lA<##EAE315>&lB<##9DFC0A>&lU<##F6A94E>&lN<##B547DC>&lD<##FFB400>&lA<##EA1515>&lN<##EAE315>&lT &7rank voucher! Congratulations!%nl%" to all players
			wait 25 ticks
			play sound "entity.firework_rocket.blast" to all players
			clear metadata value "crate-opening" of {_p}

function viewCrate(p: player, rarity: text):
	if {_rarity} = "daily":
		set {_name} to "&f&lDAILY"
		set {_pane} to white stained glass pane
	else if {_rarity} = "rare":
		set {_name} to "&9&lRARE"
		set {_pane} to blue stained glass pane
	else if {_rarity} = "epik":
		set {_name} to "&5&lEPIK"
		set {_pane} to purple stained glass pane
	else if {_rarity} = "exotic":
		set {_name} to "&2&lEXOTIC"
		set {_pane} to lime stained glass pane
	else if {_rarity} = "legendary":
		set {_name} to "&6&lLEGENDARY"
		set {_pane} to orange stained glass pane
	else if {_rarity} = "mythic":
		set {_name} to "&e&lMYTHIC"
		set {_pane} to yellow stained glass pane
	else if {_rarity} = "abundant":
		set {_name} to "&b&lABUNDANT"
		set {_pane} to light blue stained glass pane
	create a gui with virtual chest inventory with size 3 named "Crate Loot &0[%{_name}%&0]":
		make gui slot (integers between 0 and 26) with light gray stained glass pane named "&1"
		make gui slot (integers between 0 and 9) and (integers between 17 and 26) with {_pane} named "&1"
		play sound "block.chest.open" to {_p}
		if {_rarity} = "daily":
			make gui slot 10 with paper named "&a$10K" with lore "" and "&7Chance: &a30%%"
			make gui slot 11 with paper named "&d♦25" with lore "" and "&7Chance: &a30%%"
			make gui slot 12 with pumpkin named "&bPumpkin Generator &8[&fTier 2&8]" with lore "" and "&7Chance: &a30%%"
			make gui slot 13 with tripwire hook named "&9&lRARE &7Key" with lore "" and "&7Chance: &a10%%"
		else if {_rarity} = "rare":
			make gui slot 10 with paper named "&a$50K" with lore "" and "&7Chance: &a30%%"
			make gui slot 11 with paper named "&d♦50" with lore "" and "&7Chance: &a30%%"
			make gui slot 12 with melon named "&bMelon Generator &8[&fTier 3&8]" with lore "" and "&7Chance: &a20%%"
			make gui slot 13 with stone named "&bStone Generator &8[&fTier 4&8]" with lore "" and "&7Chance: &a10%%"
			make gui slot 14 with tripwire hook named "&5&lEPIK &7Key" with lore "" and "&7Chance: &a10%%"
		else if {_rarity} = "epik":
			make gui slot 10 with paper named "&a$150K" with lore "" and "&7Chance: &a30%%"
			make gui slot 11 with paper named "&d♦100" with lore "" and "&7Chance: &a20%%"
			make gui slot 12 with coal block named "&bCoal Generator &8[&fTier 5&8]" with lore "" and "&7Chance: &a20%%"
			make gui slot 13 with orange glazed terracotta named "&bCopper Generator &8[&fTier 6&8]" with lore "" and "&7Chance: &a20%%"
			make gui slot 14 with tripwire hook named "&2&lEXOTIC &7Key" with lore "" and "&7Chance: &a10%%"
		else if {_rarity} = "exotic":
			make gui slot 10 with paper named "&a$1M" with lore "" and "&7Chance: &a30%%"
			make gui slot 11 with paper named "&d♦250" with lore "" and "&7Chance: &a20%%"
			make gui slot 12 with 1 of genSlotVoucher(1) with lore "" and "&7Chance: &a15%%"
			make gui slot 13 with 1 of hopperSlotVoucher(1) with lore "" and "&7Chance: &a15%%"
			make gui slot 14 with iron block named "&bIron Generator &8[&fTier 7&8]" with lore "" and "&7Chance: &a10%%"
			make gui slot 15 with tripwire hook named "&6&lLEGENDARY &7Key" with lore "" and "&7Chance: &a10%%"
		else if {_rarity} = "legendary":
			make gui slot 10 with paper named "&a$5M" with lore "" and "&7Chance: &a30%%"
			make gui slot 11 with paper named "&d♦500" with lore "" and "&7Chance: &a20%%"
			make gui slot 12 with dark gray glazed terracotta named "&bAluminum Generator &8[&fTier 8&8]" with lore "" and "&7Chance: &a20%%"
			make gui slot 13 with 1 of genSlotVoucher(2) with lore "" and "&7Chance: &a10%%"
			make gui slot 14 with 1 of hopperSlotVoucher(2) with lore "" and "&7Chance: &a10%%"
			make gui slot 15 with tripwire hook named "&e&lMYTHIC &7Key" with lore "" and "&7Chance: &a10%%"
		else if {_rarity} = "mythic":
			make gui slot 10 with paper named "&a$50M" with lore "" and "&7Chance: &a30%%"
			make gui slot 11 with paper named "&d♦1000" with lore "" and "&7Chance: &a20%%"
			make gui slot 12 with nether quartz block named "&bQuartz Generator &8[&fTier 10&8]" with lore "" and "&7Chance: &a15%%"
			make gui slot 13 with 1 of genSlotVoucher(5) with lore "" and "&7Chance: &a15%%"
			make gui slot 14 with 1 of hopperSlotVoucher(5) with lore "" and "&7Chance: &a15%%"
			make gui slot 15 with tripwire hook named "&b&lABUNDANT &7Key" with lore "" and "&7Chance: &a5%%"
		else if {_rarity} = "abundant":
			make gui slot 10 with cyan glazed terracotta named "&bCobalt Generator &8[&fTier 15&8]" with lore "" and "&7Chance: &a30%%"
			make gui slot 11 with 1 of genSlotVoucher(15) with lore "" and "&7Chance: &a30%%"
			make gui slot 12 with 1 of hopperSlotVoucher(15) with lore "" and "&7Chance: &a30%%"
			make gui slot 13 with 2 tripwire hook named "&b&lABUNDANT &7Key" with lore "" and "&7Chance: &a9%%"
			make gui slot 14 with {item::abundantcraterankvoucher} with lore "", "&7&o(Only seasonal)", "" and "&7Chance: &a1%%"
	open the last gui to {_p}

function getRarity(b: block) :: text:
	set {_r} to "%{_b}%"
	if {_r} contains "white":
		return "daily"
	else if {_r} contains "light blue":
		return "abundant"
	else if {_r} contains "purple":
		return "epik"
	else if {_r} contains "blue":
		return "rare"
	else if {_r} contains "lime":
		return "exotic"
	else if {_r} contains "orange":
		return "legendary"
	else if {_r} contains "yellow":
		return "mythic"
	else:
		return "null"

function genSlotVoucher(gens: number) :: item:
	set {_item} to 1 paper named "&b+%{_gens}% &fGen Slot Voucher" with lore "&7" and "&8• &7Right-click to claim"
	return {_item}

function hopperSlotVoucher(hoppers: number) :: item:
	set {_item} to 1 paper named "&b+%{_hoppers}% &fHopper Slot Voucher" with lore "&7" and "&8• &7Right-click to claim"
	return {_item}

function plotVoucher(plots: number) :: item:
	set {_item} to 1 paper named "&b+%{_plots}% &fPlot Voucher" with lore "&7" and "&8• &7Right-click to claim"
	return {_item}

function multiplierVoucher(multiplier: number) :: item:
	set {_item} to 1 paper named "&b+%{_multiplier}% &fMultiplier Voucher" with lore "&7" and "&8• &7Right-click to claim"
	return {_item}

function crystalVoucher(crystals: number) :: item:
	set {_item} to 1 paper named "&b+%{_crystals}% &fCrystal Voucher" with lore "&7" and "&8• &7Right-click to claim"
	return {_item}

function moneyVoucher(money: number) :: item:
	set {_item} to 1 paper named "&b$%{_money}% &fVoucher" with lore "&7" and "&8• &7Right-click to claim"
	return {_item}

on right click:
	event-item is paper
	if name of event-item contains "Slot Voucher" or "Plot Voucher" or "Voucher" or "Crystal Voucher":
		line 2 of event-item's lore is "&8• &7Right-click to claim"
		set {_lore} to name of event-item
		replace all " Slot Voucher", "&f", and "&b+" in {_lore} with ""
		replace all " Voucher" and " &fVoucher" in {_lore} with ""
		set {_types::*} to {_lore} split at " "
		if {_types::2} is "Gen":
			add {_types::1} parsed as a number to {generator::limit::%player's uuid%}
			send "{@prefix} &7You claimed a &b+%{_types::1}% &b%{_types::2}% &bSlot Voucher!" to player
		else if {_types::2} is "Hopper":
			add {_types::1} parsed as a number to {hopper::limit::%player's uuid%}
			send "{@prefix} &7You claimed a &b+%{_types::1}% &b%{_types::2}% &bSlot Voucher!" to player
		else if {_types::2} is "Crystal":
			add {_types::1} parsed as a number to {crystals::%player's uuid%}
			send "{@prefix} &7You claimed a &b+%{_types::1}% &b%{_types::2}% &bVoucher!" to player
		else if {_types::2} is "Multiplier":
			add {_types::1} parsed as a number to {multiplier::%player's uuid%}
			send "{@prefix} &7You claimed a &b+%{_types::1}% &b%{_types::2}% &bVoucher!" to player
		else if {_types::2} is "Plot":
			send "{@prefix} &7You claimed a &b+%{_types::1}% &b%{_types::2}% &bVoucher!" to player
			addPlots(player, {_types::1} parsed as a number)
		else if {_types::1} contains "$":
			replace all "&b$" in {_types::1} with ""
			add {_types::1} parsed as a number to {balance::%player's uuid%}
			send "{@prefix} &7You claimed a &b$%formatmoney({_types::1} parsed as a number)% &bVoucher!" to player
		else if name of event-item contains "Rank Voucher":
			if uncolored name of event-item contains "ABUNDANT":
				send "{@prefix} &7You claimed <##EA1515>&lA<##EAE315>&lB<##9DFC0A>&lU<##F6A94E>&lN<##B547DC>&lD<##FFB400>&lA<##EA1515>&lN<##EAE315>&lT &fRank!" to player
				execute console command "/lp user %player% permission set seasonal.abundantrank true" if player does not have permission "group.abundant"
				execute console command "/rankgive %player% abundant" if player does not have permission "group.abundant"
			else:
				send "{@prefix} &7You claimed <##EA1515>&lAPPLE &fRank!" to player
				execute console command "/lp user %player% permission set seasonal.applerank true" if player does not have permission "group.apple"
				execute console command "/rankgive %player% apple" if player does not have permission "group.apple"
		remove 1 of event-item from player's inventory
		play sound "entity.arrow.hit_player" at pitch 2 to player