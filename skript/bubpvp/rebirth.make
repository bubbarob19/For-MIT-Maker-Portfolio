function rebirth(p: player):
	set {_u} to uuid of {_p}
	open virtual hopper inventory named "&8Confirm" to {_p}
	format gui slot (integers between 0 and 4) of {_p} with black stained glass pane named "&1"
	format gui slot 2 of {_p} with red stained glass named "&4&lREBIRTH" with lore "", "&7Are you sure you want to rebirth?", "", "&7Rebirthing will reset EVERYTHING", "&7except for your ranks, level,", "&7and level multiplier.", "", "&7When you rebirth, you will", "&7receive a &a+100%% &7level", "&7multiplier, allowing you to", "&7level up way faster.", "", "&c&lWAIT 3 SECONDS"
	wait 3 seconds
	format gui slot 2 of {_p} with lime stained glass named "&a&lREBIRTH" with lore "", "&7Are you sure you want to rebirth?", "", "&7Rebirthing will reset EVERYTHING", "&7except for your ranks, level,", "&7and level multiplier.", "", "&7When you rebirth, you will", "&7receive a &a+100%% &7level", "&7multiplier, allowing you to", "&7level up way faster.", "", "&a&lCLICK HERE TO REBIRTH" to run:
		resetPlayerStats({_p})
		play sound "block.portal.travel" at pitch 0 to {_p}
		teleport {_p} to {spawn}
		execute console command "/broadcast &d&lREBIRTH: &f%{_p}% &7just &fREBIRTHED!"
		if {levelmulti::%{_u}%} is not set:
			set {levelmulti::%{_u}%} to 1
		add 1 to {levelmulti::%{_u}%}
		apply blindness to {_p} for 5 seconds
		wait 5 seconds
		remove blindness from {_p}

function resetPlayerStats(p: player):
	set {_u} to uuid of {_p}
	clear {_p}'s inventory
	clear {_p}'s enderchest
	set slot 0 of {_p} to {rpgitem::sword1}
	set slot 1 of {_p} to {rpgitem::pick1}
	set slot 2 of {_p} to 3 of golden apple
	set {balance::%{_u}%} to 0
	set {kills::%{_u}%} to 0
	set {killstreak::%{_u}%} to 0
	set {deaths::%{_u}%} to 0
	set {cfprofit::%{_u}%} to 0
	set {cfloss::%{_u}%} to 0
	set {cfwin::%{_u}%} to 0
	set {clprofit::%{_u}%} to 0
	set {clloss::%{_u}%} to 0
	set {clwin::%{_u}%} to 0
	set {battlepass::%{_u}%} to 0
	loop indices of {bpdetect::*}:
		delete {bpdetect::%loop-value%::%{_u}%}
	set {bpdetect::1::%{_u}%} to 0
	set {bpdetect::6::%{_u}%} to 0
	set {bpdetect::7::%{_u}%} to 0
	set {bpdetect::9::%{_u}%} to 0
	set {bpdetect::12::%{_u}%} to 0
	set {bpdetect::16::%{_u}%} to 0
	set {bpdetect::23::%{_u}%} to 0
	delete {reward::%{_u}%::*}
	delete {bounty::%{_u}%}
	delete {ah::amount::%{_u}%}
	loop indices of {ah::price::*}:
		delete {ah::price::%loop-value%::%{_u}%}
	loop indices of {ah::listtime::*}:
		delete {ah::listtime::%loop-value%::%{_u}%}
	loop indices of {ah::item::*}:
		delete {ah::item::%loop-value%::%{_u}%}
	loop indices of {ah::expiredtime::*}:
		delete {ah::expiredtime::%loop-value%::%{_u}%}
	loop all players:
		if name of loop-player's current inventory contains "&8Auction House &7| &8Page &c":
			set {_name} to name of loop-player's current inventory
			replace all "&8Auction House &7| &8Page &c" in {_name} with ""
			set {_page} to {_name} parsed as a number
			auctionHouse(loop-player, {_page})

on drop:
	if name of player's current inventory is "&8Confirm":
		cancel event

command /rebirth:
	trigger:
		play sound "entity.chicken.egg" to player
		rebirthMenu(player)

function rebirthMenu(p: player):
	set {_u} to uuid of {_p}
	open virtual dropper inventory named "&8Rebirth Menu" to {_p}
	format gui slot (integers between 0 and 8) of {_p} with light gray stained glass pane named "&1"
	if {_p}'s inventory contains {rpgitem::helmet25}:
		add 1 to {_num}
		set {_lore::1} to "&a✔ LVL 25 Netherite Helmet"
	else:
		set {_lore::1} to "&c✖ LVL 25 Netherite Helmet"
	if {_p}'s inventory contains {rpgitem::chestplate25}:
		add 1 to {_num}
		set {_lore::2} to "&a✔ LVL 25 Netherite Chestplate"
	else:
		set {_lore::2} to "&c✖ LVL 25 Netherite Chestplate"
	if {_p}'s inventory contains {rpgitem::legging25}:
		add 1 to {_num}
		set {_lore::3} to "&a✔ LVL 25 Netherite Leggings"
	else:
		set {_lore::3} to "&c✖ LVL 25 Netherite Leggings"
	if {_p}'s inventory contains {rpgitem::boot25}:
		add 1 to {_num}
		set {_lore::4} to "&a✔ LVL 25 Netherite Boots"
	else:
		set {_lore::4} to "&c✖ LVL 25 Netherite Boots"
	if {_p}'s inventory contains {rpgitem::sword50}:
		add 1 to {_num}
		set {_lore::5} to "&a✔ LVL 50 Netherite Sword"
	else:
		set {_lore::5} to "&c✖ LVL 50 Netherite Sword"
	if {_p}'s inventory contains {rpgitem::pick50}:
		add 1 to {_num}
		set {_lore::6} to "&a✔ LVL 50 Netherite Pickaxe"
	else:
		set {_lore::6} to "&c✖ LVL 50 Netherite Pickaxe"
	if {balance::%{_u}%} is greater than or equal to 25000:
		add 1 to {_num}
		set {_lore::7} to "&a✔ $25,000"
	else:
		set {_lore::7} to "&c✖ $25,000"
	if {battlepass::%{_u}%} is equal to 25:
		add 1 to {_num}
		set {_lore::8} to "&a✔ Max Battlepass"
	else:
		set {_lore::8} to "&c✖ Max Battlepass"
	if {_num} is 8:
		set {_i} to lime concrete named "&2&lREBIRTH" with lore "%{_lore::1}%", "%{_lore::2}%", "%{_lore::3}%", "%{_lore::4}%", "%{_lore::5}%", "%{_lore::6}%", "%{_lore::7}%" and "%{_lore::8}%"
	else:
		set {_i} to red concrete named "&4&lREBIRTH" with lore "%{_lore::1}%", "%{_lore::2}%", "%{_lore::3}%", "%{_lore::4}%", "%{_lore::5}%", "%{_lore::6}%", "%{_lore::7}%" and "%{_lore::8}%"
	format gui slot 4 of {_p} with {_i} to run:
		if name of event-item contains "&2":
			rebirth({_p})
		else:
			play sound "entity.villager.no" to {_p}
			send "&4ERROR: &cYou do not yet meet the requirements to rebirth!" to {_p}