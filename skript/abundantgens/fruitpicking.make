#FRUIT PICKING

#OPTIONS

options:
	prefix: &b&lABUNDANT &8•
	apple: <##EA1515>
	pineapple: <##EAE315>
	kiwi: <##9DFC0A>
	peach: <##F6A94E>
	grape: <##B547DC>
	tangerine: <##FFB400>

#COMMANDS

command /fruitbasket:
	aliases: /fb
	trigger:
		play sound "entity.chicken.egg" at pitch 0 to player
		fruitBasket(player)

on right click:
	if {testing::%player's uuid%} is set:
		set {_tag} to "SkullOwner" tag of event-block's nbt
		set {fruit::data::%{_tag}%} to {testing::%player's uuid%}
		delete {testing::%player's uuid%}

on right click:
	if player's tool is {item::fruiticecream}:
		cancel event
		remove 1 of {item::fruiticecream} from player's inventory
		play sound "entity.generic.eat" to player
		apply swiftness 3 to player for 3 minutes
	else if player's tool is {item::fruitsmoothie}:
		cancel event
		remove 1 of {item::fruitsmoothie} from player's inventory
		play sound "entity.generic.eat" to player
		apply strength 2 to player for 3 minutes
	else if player's tool is {item::goldenapple}:
		cancel event
		remove 1 of {item::goldenapple} from player's inventory
		play sound "entity.generic.eat" to player
		apply regeneration 1 to player for 3 minutes
	else if player's tool is {item::partyfruit}:
		cancel event
		remove 1 of {item::partyfruit} from player's inventory
		play sound "entity.generic.eat" to player
		boosterCreate(2, 30 minutes, "personal", player)

#EVENTS

on right click:
	if "%region at player's location%" contains "fruit-picking":
		set {_tag} to "SkullOwner" tag of event-block's nbt
		if {fruit::data::%{_tag}%} is set:
			cancel event
			pickFruit(player, event-block, {fruit::data::%{_tag}%}, "%{_tag}%")

on right click:
	if player's tool is {item::playerfruitbasket}:
		play sound "entity.chicken.egg" at pitch 0 to player
		fruitBasket(player)

on load:
	delete {fruit::picking::status::*}
	loop {blocksaves::fruitpicking::location::*}:
		set block at loop-value to {blocksaves::fruitpicking::bd::%loop-index%}
		set nbt of block at loop-value to {blocksaves::fruitpicking::nbt::%loop-index%}
	delete {blocksaves::fruitpicking::location::*}
	delete {blocksaves::fruitpicking::bd::*}
	delete {blocksaves::fruitpicking::nbt::*}

#FUNCTIONS

function pickFruit(p: player, b: block, type: text, tag: text):
	set {_l} to location of {_b}
	if {fruit::picking::status::%{_l}%} is not set:
		set {fruit::picking::status::%{_l}%} to 0
	if line 5 of lore of {_p}'s tool contains "Harvest Speed":
		set {_chance} to line 5 of lore of {_p}'s tool
		replace all "&8• &b+" and "%% Harvest Speed" in {_chance} with ""
		set {_num} to a random integer between 1 and 100
		if {_num} <= {_chance} parsed as a number:
			add 2 to {fruit::picking::status::%{_l}%}
		else:
			add 1 to {fruit::picking::status::%{_l}%}
	else:
		add 1 to {fruit::picking::status::%{_l}%}
	if {fruit::picking::status::%{_l}%} < 15:
		set {_progbar} to progressBar("&b", "&7", "|", 15, ({fruit::picking::status::%{_l}%} / 15))
		send action bar "&f&lFRUIT PICKING &8| &b%{_progbar}%" to {_p}
	else:
		play sound "block.wool.place" at pitch 2 to {_p}
		send action bar "&f&lFRUIT PICKING &8| &a&lSUCCESS" to {_p}
		delete {fruit::picking::status::%{_l}%}
		addFruitToBasket({_p}, {_type})
		if {_p}'s tool is {item::holyfruitpicker}:
			set {_num} to a random integer between 1 and 100
			if {_num} is between 1 and 25:
				addFruitToBasket({_p}, {_type})
				send action bar "&e&lLUCKY &8| &7You got an extra fruit!" to {_p}
		set {_nbt} to nbt compound copy of {_b}
		set {_bd} to block data of {_b}
		set {_id} to genCode(20)
		set {blocksaves::fruitpicking::nbt::%{_id}%} to {_nbt}
		set {blocksaves::fruitpicking::bd::%{_id}%} to {_bd}
		set {blocksaves::fruitpicking::location::%{_id}%} to {_l}
		set block at {_l} to air
		wait 30 seconds
		set block at {_l} to {_bd}
		set nbt of block at {_l} to {_nbt}
		delete {blocksaves::fruitpicking::bd::%{_id}%}
		delete {blocksaves::fruitpicking::location::%{_id}%}
		delete {blocksaves::fruitpicking::nbt::%{_id}%}

function getFruitBasketTotalSize(p: player) :: number:
	set {_u} to uuid of {_p}
	set {_n} to 0
	loop indices of {fruit::basket::amount::*}:
		add {fruit::basket::amount::%loop-value%::%{_u}%} to {_n}
	return {_n}

function getSizeName(size: number) :: text:
	if {_size} is 25:
		return "Tiny"
	else if {_size} is 50:
		return "Miniscule"
	else if {_size} is 75:
		return "Small"
	else if {_size} is 100:
		return "Medium"
	else if {_size} is 150:
		return "Large"
	else if {_size} is 200:
		return "Huge"
	else:
		return {_size}

function addFruitToBasket(p: player, type: text):
	set {_u} to uuid of {_p}
	if getFruitBasketTotalSize({_p}) is less than {fruit::basket::size::%{_u}%}:
		add 1 to {fruit::basket::amount::%{_type}%::%{_u}%}
	else:
		send "{@prefix} &7You cannot hold this fruit in your basket! Upgrade your fruit basket to hold more fruit!" to {_p}
		play sound "entity.arrow.hit_player" at pitch 0 to {_p}

function fruitBasket(p: player):
	set {_u} to uuid of {_p}
	create a gui with virtual chest inventory with size 6 named "Fruit Basket":
		make gui slot (integers between 0 and 53) with light gray stained glass pane named "&1"
		make gui slot (integers between 45 and 53) with black stained glass pane named "&1"
		make gui slot 53 with barrier named "&4Close Fruit Basket":
			close {_p}'s inventory
			play sound "entity.chicken.egg" at pitch 0 to {_p}
		make gui slot 10 with {item::apple} named "{@apple}&lAPPLE" with lore "&7", "&7Amount: {@apple}%{fruit::basket::amount::apple::%{_u}%}%", "&7", "&8• &7Upgrade your basket size" and "&7to hold more fruit!"
		make gui slot 11 with {item::pineapple} named "{@pineapple}&lPINEAPPLE" with lore "&7", "&7Amount: {@pineapple}%{fruit::basket::amount::pineapple::%{_u}%}%", "&7", "&8• &7Upgrade your basket size" and "&7to hold more fruit!"
		make gui slot 12 with {item::kiwi} named "{@kiwi}&lKIWI" with lore "&7", "&7Amount: {@kiwi}%{fruit::basket::amount::kiwi::%{_u}%}%", "&7", "&8• &7Upgrade your basket size" and "&7to hold more fruit!"
		make gui slot 13 with {item::peach} named "{@peach}&lPEACH" with lore "&7", "&7Amount: {@peach}%{fruit::basket::amount::peach::%{_u}%}%", "&7", "&8• &7Upgrade your basket size" and "&7to hold more fruit!"
		make gui slot 14 with {item::grape} named "{@grape}&lGRAPE" with lore "&7", "&7Amount: {@grape}%{fruit::basket::amount::grape::%{_u}%}%", "&7", "&8• &7Upgrade your basket size" and "&7to hold more fruit!"
		make gui slot 15 with {item::tangerine} named "{@tangerine}&lTANGERINE" with lore "&7", "&7Amount: {@tangerine}%{fruit::basket::amount::tangerine::%{_u}%}%", "&7", "&8• &7Upgrade your basket size" and "&7to hold more fruit!"
		make gui slot 16 with {item::fruitbasket} named "&fFruit Basket Contents" with lore "&7", "&7Total Contents: &f%getFruitBasketTotalSize({_p})%&7/&f%{fruit::basket::size::%{_u}%}%", "&7", "&8• &7Upgrade your basket size" and "&7to hold more fruit!"
		make gui slot 28 with {item::basket} named "&fBasket Size" with lore "&7", "&7Current Size: &f%getSizeName({fruit::basket::size::%{_u}%})%", "&7Total Fruit Capacity: &f%{fruit::basket::size::%{_u}%}%", "&7", "&8• &7Click &bhere &7to upgrade" and "&7your basket size!":
			play sound "entity.chicken.egg" at pitch 0 to {_p}
			upgradeFruitBasketSize({_p})
		make gui slot 30 with {item::moneybag} named "&fSell Your Fruits" with lore "&7", "&8• &7Click &bhere &7to sell" and "&7your fruits for crystals!":
			play sound "entity.chicken.egg" at pitch 0 to {_p}
			sellFruitsMenu({_p})
		make gui slot 32 with stick named "&fPurchase Fruit Picking Tools" with lore "&7", "&8• &7Click &bhere &7to" and "&7browse or purchase!":
			play sound "entity.chicken.egg" at pitch 0 to {_p}
			buyFruitPickingToolMenu({_p})
		make gui slot 34 with golden apple named "&fCraft Snacks" with lore "&7", "&8• &7Craft tasty snacks here", "&7with your fruits!", "", "&8• &7Snacks give special" and "&7effects / abilities!":
			play sound "entity.chicken.egg" at pitch 0 to {_p}
			fruitSnacksMenu({_p})
	open the last gui to {_p}

function sellFruitsMenu(p: player):
	set {_u} to uuid of {_p}
	create a gui with id "sellfruits-%{_u}%" with virtual chest inventory with size 4 named "Sell Fruits":
		run on gui close:
			delete gui with id "sellfruits-%{_u}%"
		make gui slot (integers between 0 and 35) with light gray stained glass pane named "&1"
		make gui slot (integers between 27 and 35) with black stained glass pane named "&1"
		make gui slot 35 with barrier named "&4Back":
			play sound "entity.chicken.egg" at pitch 0 to {_p}
			fruitBasket({_p})
		formatFruitSellMenuSlot({_p}, 10, "{@apple}", "{@apple}&lAPPLE", "apple", 3)
		formatFruitSellMenuSlot({_p}, 11, "{@pineapple}", "{@pineapple}&lPINEAPPLE", "pineapple", 3)
		formatFruitSellMenuSlot({_p}, 12, "{@kiwi}", "{@kiwi}&lKIWI", "kiwi", 3)
		formatFruitSellMenuSlot({_p}, 13, "{@peach}", "{@peach}&lPEACH", "peach", 3)
		formatFruitSellMenuSlot({_p}, 14, "{@grape}", "{@grape}&lGRAPE", "grape", 3)
		formatFruitSellMenuSlot({_p}, 15, "{@tangerine}", "{@tangerine}&lTANGERINE", "tangerine", 3)
		make gui slot 16 with {item::fruitbasket} named "&7Sell All" with lore "", "&8• &7Click &bhere &7to sell", "&7all of your fruit!", "", "&7Total Fruit Amount: &f%getFruitBasketTotalSize({_p})%" and "&7Worth: &d♦%getFruitBasketTotalSize({_p}) * 3%":
			if getFruitBasketTotalSize({_p}) is not 0:
				add (getFruitBasketTotalSize({_p}) * 3) to {crystals::%{_u}%}
				loop indices of {fruit::basket::amount::*}:
					set {fruit::basket::amount::%loop-value%::%{_u}%} to 0
				play sound "entity.arrow.hit_player" at pitch 1.9 to {_p}
				sellFruitsMenu({_p})
			else:
				error({_p}, "You do not have any fruit to sell!")
	open the last gui to {_p}

function formatFruitSellMenuSlot(p: player, slot: number, color: text, name: text, type: text, worth: number):
	set {_u} to uuid of {_p}
	edit gui with id "sellfruits-%{_u}%":
		make gui slot {_slot} with {item::%{_type}%} named {_name} with lore "", "&8• &7Click to sell %{_color}%1 &7%{_type}%", "&8• &7Shift-click to sell %{_color}%all", "&7of your &7%{_type}%&7s", "", "&7Worth: &d♦%{_worth}%", "" and "&7Your Amount: %{_color}%%{fruit::basket::amount::%{_type}%::%{_u}%}%":
			if {fruit::basket::amount::%{_type}%::%{_u}%} is not 0:
				if click type is left mouse button or right mouse button:
					subtract 1 from {fruit::basket::amount::%{_type}%::%{_u}%}
					add {_worth} to {crystals::%{_u}%}
					play sound "entity.arrow.hit_player" at pitch 1.9 to {_p}
				else if click type is left mouse button with shift or right mouse button with shift:
					add ({fruit::basket::amount::%{_type}%::%{_u}%} * {_worth}) to {crystals::%{_u}%}
					set {fruit::basket::amount::%{_type}%::%{_u}%} to 0
					play sound "block.note_block.pling" at pitch 1.9 to {_p}
				sellFruitsMenu({_p})
			else:
				error({_p}, "You do not have any fruit to sell!")

function upgradeFruitBasketSize(p: player):
	set {_u} to uuid of {_p}
	create a gui with id "upgradebasketsize-%{_u}%" with virtual chest inventory with size 4 named "Upgrade Fruit Basket Size":
		run on gui close:
			delete gui with id "upgradebasketsize-%{_u}%"
		make gui slot (integers between 0 and 35) with light gray stained glass pane named "&1"
		make gui slot (integers between 27 and 35) with black stained glass pane named "&1"
		make gui slot 35 with barrier named "&4Back":
			play sound "entity.chicken.egg" at pitch 0 to {_p}
			fruitBasket({_p})
		make gui slot 10 with {item::basket} named "&fYour Basket" with lore "&7", "&7Current Size: &f%getSizeName({fruit::basket::size::%{_u}%})%" and "&7Total Fruit Capacity: &f%{fruit::basket::size::%{_u}%}%"
		formatFruitBasketSizeUpgradeSlot({_p}, 12, oak button, "&fTiny -> Miniscule", 100, 25, 50)
		formatFruitBasketSizeUpgradeSlot({_p}, 13, stick, "&fMiniscule -> Small", 250, 50, 75)
		formatFruitBasketSizeUpgradeSlot({_p}, 14, oak pressure plate, "&fSmall -> Medium", 500, 75, 100)
		formatFruitBasketSizeUpgradeSlot({_p}, 15, oak plank, "&fMedium -> Large", 1000, 100, 150)
		formatFruitBasketSizeUpgradeSlot({_p}, 16, oak log, "&fLarge -> Huge", 2500, 150, 200)
	open the last gui to {_p}

function formatFruitBasketSizeUpgradeSlot(p: player, slot: number, item: item, name: text, cost: number, previoussize: number, size: number):
	set {_u} to uuid of {_p}
	edit gui with id "upgradebasketsize-%{_u}%":
		if {_previoussize} = {fruit::basket::size::%{_u}%}:
			make gui slot {_slot} with {_item} named {_name} with lore "", "&7Cost: &d♦%{_cost}%", "" and "&8• &7Click &bhere &7to upgrade":
				if {crystals::%{_u}%} is greater than or equal to {_cost}:
					subtract {_cost} from {crystals::%{_u}%}
					set {fruit::basket::size::%{_u}%} to {_size}
					send "{@prefix} &7You upgraded your fruit basket size to &f%getSizeName({_size})% &8(&7%{_size}% &7slots&8)" to {_p}
					play sound "ui.loom.take_result" to {_p}
					upgradeFruitBasketSize({_p})
				else:
					error({_p}, "You do not have enough crystals for this!")
		else if {_previoussize} > {fruit::basket::size::%{_u}%}:
			make gui slot {_slot} with {_item} named {_name} with lore "", "&7Cost: &d♦%{_cost}%", "", "&8• &4&lLOCKED", "", "&8• &7Purchase the previous" and "&7upgrade(s) first!"
		else:
			make gui slot {_slot} with {_item} named {_name} with lore "", "&7Cost: &d♦%{_cost}%", "" and "&8• &c&lALREADY PURCHASED"

function fruitSnacksMenu(p: player):
	set {_u} to uuid of {_p}
	create a gui with virtual chest inventory with size 4 named "Craft Fruit Snacks":
		make gui slot (integers between 0 and 35) with light gray stained glass pane named "&1"
		make gui slot (integers between 27 and 35) with black stained glass pane named "&1"
		make gui slot 35 with barrier named "&4Back":
			play sound "entity.chicken.egg" at pitch 0 to {_p}
			fruitBasket({_p})
		set {_fruiticecream} to {item::fruiticecream}
		set {_fruitsmoothie} to {item::fruitsmoothie}
		set {_goldenapple} to {item::goldenapple}
		set {_partyfruit} to {item::partyfruit}
		add {_fruiticecream} to {_itemlist::*}
		add {_fruitsmoothie} to {_itemlist::*}
		add {_goldenapple} to {_itemlist::*}
		add {_partyfruit} to {_itemlist::*}
		loop {_itemlist::*}:
			set line ( getLoreLines({_itemlist::%loop-index%}) + 1 ) of {_itemlist::%loop-index%}'s lore to ""
			set line ( getLoreLines({_itemlist::%loop-index%}) + 1 ) of {_itemlist::%loop-index%}'s lore to "&7&m &m &m &m &m &m &m &m &m &m &m &m &m &m &m &m &m &m &m &m &m &m &m &m &m &m &m &m &m &m &m &m &m &m &m &m"
			set line ( getLoreLines({_itemlist::%loop-index%}) + 1 ) of {_itemlist::%loop-index%}'s lore to ""
			set line ( getLoreLines({_itemlist::%loop-index%}) + 1 ) of {_itemlist::%loop-index%}'s lore to "&fRequired Materials:"
			set line ( getLoreLines({_itemlist::%loop-index%}) + 1 ) of {_itemlist::%loop-index%}'s lore to ""
		set line ( getLoreLines({_itemlist::1}) + 1 ) of {_itemlist::1}'s lore to "{@apple}Apples: &710"
		set line ( getLoreLines({_itemlist::1}) + 1 ) of {_itemlist::1}'s lore to "{@pineapple}Pineapples: &710"
		set line ( getLoreLines({_itemlist::1}) + 1 ) of {_itemlist::1}'s lore to "{@tangerine}Tangerines: &75"
		set line ( getLoreLines({_itemlist::2}) + 1 ) of {_itemlist::2}'s lore to "{@kiwi}Kiwis: &75"
		set line ( getLoreLines({_itemlist::2}) + 1 ) of {_itemlist::2}'s lore to "{@peach}Peaches: &75"
		set line ( getLoreLines({_itemlist::2}) + 1 ) of {_itemlist::2}'s lore to "{@grape}Grapes: &715"
		set line ( getLoreLines({_itemlist::3}) + 1 ) of {_itemlist::3}'s lore to "{@apple}Apples: &720"
		set line ( getLoreLines({_itemlist::3}) + 1 ) of {_itemlist::3}'s lore to "{@pineapple}Pineapples: &71"
		set line ( getLoreLines({_itemlist::3}) + 1 ) of {_itemlist::3}'s lore to "{@kiwi}Kiwis: &71"
		set line ( getLoreLines({_itemlist::3}) + 1 ) of {_itemlist::3}'s lore to "{@peach}Peaches: &71"
		set line ( getLoreLines({_itemlist::3}) + 1 ) of {_itemlist::3}'s lore to "{@grape}Grapes: &71"
		set line ( getLoreLines({_itemlist::3}) + 1 ) of {_itemlist::3}'s lore to "{@tangerine}Tangerines: &71"
		set line ( getLoreLines({_itemlist::4}) + 1 ) of {_itemlist::4}'s lore to "{@apple}Apples: &730"
		set line ( getLoreLines({_itemlist::4}) + 1 ) of {_itemlist::4}'s lore to "{@pineapple}Pineapples: &730"
		set line ( getLoreLines({_itemlist::4}) + 1 ) of {_itemlist::4}'s lore to "{@kiwi}Kiwis: &730"
		set line ( getLoreLines({_itemlist::4}) + 1 ) of {_itemlist::4}'s lore to "{@peach}Peaches: &730"
		set line ( getLoreLines({_itemlist::4}) + 1 ) of {_itemlist::4}'s lore to "{@grape}Grapes: &730"
		set line ( getLoreLines({_itemlist::4}) + 1 ) of {_itemlist::4}'s lore to "{@tangerine}Tangerines: &730"
		loop {_itemlist::*}:
			set line ( getLoreLines({_itemlist::%loop-index%}) + 1 ) of {_itemlist::%loop-index%}'s lore to ""
			set line ( getLoreLines({_itemlist::%loop-index%}) + 1 ) of {_itemlist::%loop-index%}'s lore to "&8• &7Click &bhere &7to craft"
		make gui slot 10 with {_itemlist::1}:
			if {fruit::basket::amount::apple::%{_u}%} >= 10:
				if {fruit::basket::amount::pineapple::%{_u}%} >= 10:
					if {fruit::basket::amount::tangerine::%{_u}%} >= 5:
						if {_p} can hold {item::fruiticecream}:
							subtract 10 from {fruit::basket::amount::apple::%{_u}%}
							subtract 10 from {fruit::basket::amount::pineapple::%{_u}%}
							subtract 5 from {fruit::basket::amount::tangerine::%{_u}%}
							give {_p} 1 of {item::fruiticecream}
							send "{@prefix} &7You crafted a bowl of &fFruit Icecream&7!" to {_p}
							play sound "entity.arrow.hit_player" at pitch 2 to {_p}
						else:
							error(player, "You do not have enough inventory space!")
					else:
						error(player, "Insufficient materials!")
				else:
					error(player, "Insufficient materials!")
			else:
				error(player, "Insufficient materials!")
		make gui slot 12 with {_itemlist::2}:
			if {fruit::basket::amount::grape::%{_u}%} >= 15: 
				if {fruit::basket::amount::kiwi::%{_u}%} >= 5: 
					if {fruit::basket::amount::peach::%{_u}%} >= 5:
						if {_p} can hold {item::fruitsmoothie}:
							subtract 15 from {fruit::basket::amount::grape::%{_u}%}
							subtract 5 from {fruit::basket::amount::peach::%{_u}%}
							subtract 5 from {fruit::basket::amount::kiwi::%{_u}%}
							give {_p} 1 of {item::fruitsmoothie}
							send "{@prefix} &7You crafted a &fFruit Smoothie&7!" to {_p}
							play sound "entity.arrow.hit_player" at pitch 2 to {_p}
						else:
							error(player, "You do not have enough inventory space!")
					else:
						error(player, "Insufficient materials!")
				else:
					error(player, "Insufficient materials!")
			else:
				error(player, "Insufficient materials!")
		make gui slot 14 with {_itemlist::3}:
			if {fruit::basket::amount::apple::%{_u}%} >= 20:
				if {fruit::basket::amount::pineapple::%{_u}%} >= 1:
					if {fruit::basket::amount::tangerine::%{_u}%} >= 1: 
						if {fruit::basket::amount::grape::%{_u}%} >= 1: 
							if {fruit::basket::amount::kiwi::%{_u}%} >= 1: 
								if {fruit::basket::amount::peach::%{_u}%} >= 1:
									if {_p} can hold {item::goldenapple}:
										subtract 20 from {fruit::basket::amount::apple::%{_u}%}
										subtract 1 from {fruit::basket::amount::pineapple::%{_u}%}
										subtract 1 from {fruit::basket::amount::tangerine::%{_u}%}
										subtract 1 from {fruit::basket::amount::grape::%{_u}%}
										subtract 1 from {fruit::basket::amount::peach::%{_u}%}
										subtract 1 from {fruit::basket::amount::kiwi::%{_u}%}
										give {_p} 1 of {item::goldenapple}
										send "{@prefix} &7You crafted a &fGolden Apple&7!" to {_p}
										play sound "entity.arrow.hit_player" at pitch 2 to {_p}
									else:
										error(player, "You do not have enough inventory space!")
								else:
									error(player, "Insufficient materials!")
							else:
								error(player, "Insufficient materials!")
						else:
							error(player, "Insufficient materials!")
					else:
						error(player, "Insufficient materials!")
				else:
					error(player, "Insufficient materials!")
			else:
				error(player, "Insufficient materials!")
		make gui slot 16 with {_itemlist::4}:
			if {fruit::basket::amount::apple::%{_u}%} >= 30:
				if {fruit::basket::amount::pineapple::%{_u}%} >= 30:
					if {fruit::basket::amount::tangerine::%{_u}%} >= 30:
						if {fruit::basket::amount::grape::%{_u}%} >= 30:
							if {fruit::basket::amount::kiwi::%{_u}%} >= 30:
								if {fruit::basket::amount::peach::%{_u}%} >= 30:
									if {_p} can hold {item::partyfruit}:
										subtract 30 from {fruit::basket::amount::apple::%{_u}%}
										subtract 30 from {fruit::basket::amount::pineapple::%{_u}%}
										subtract 30 from {fruit::basket::amount::tangerine::%{_u}%}
										subtract 30 from {fruit::basket::amount::grape::%{_u}%}
										subtract 30 from {fruit::basket::amount::peach::%{_u}%}
										subtract 30 from {fruit::basket::amount::kiwi::%{_u}%}
										give {_p} 1 of {item::partyfruit}
										send "{@prefix} &7You crafted a &fParty Fruit&7!" to {_p}
										play sound "entity.arrow.hit_player" at pitch 2 to {_p}
									else:
										error(player, "You do not have enough inventory space!")
								else:
									error(player, "Insufficient materials!")
							else:
								error(player, "Insufficient materials!")
						else:
							error(player, "Insufficient materials!")
					else:
						error(player, "Insufficient materials!")
				else:
					error(player, "Insufficient materials!")
			else:
				error(player, "Insufficient materials!")
	open the last gui to {_p}

function buyFruitPickingToolMenu(p: player):
	set {_u} to uuid of {_p}
	create a gui with id "fruitpickingtoolmenu-%{_u}%" with virtual chest inventory with size 4 named "Buy Fruit Picking Tools":
		run on gui close:
			delete gui with id "fruitpickingtoolmenu-%{_u}%"
		make gui slot (integers between 0 and 35) with light gray stained glass pane named "&1"
		make gui slot (integers between 27 and 35) with black stained glass pane named "&1"
		make gui slot 35 with barrier named "&4Back":
			play sound "entity.chicken.egg" at pitch 0 to {_p}
			fruitBasket({_p})
		make gui slot 10 with {item::basket} named "&fYour Resources" with lore "", "{@apple}Apples: &7%{fruit::basket::amount::apple::%{_u}%}%", "{@pineapple}Pineapples: &7%{fruit::basket::amount::pineapple::%{_u}%}%", "{@kiwi}Kiwis: &7%{fruit::basket::amount::kiwi::%{_u}%}%", "{@peach}Peaches: &7%{fruit::basket::amount::peach::%{_u}%}%", "{@grape}Grapes: &7%{fruit::basket::amount::grape::%{_u}%}%", "{@tangerine}Tangerines: &7%{fruit::basket::amount::tangerine::%{_u}%}%", "" and "&7Crystals: &d♦%formatmoney({crystals::%{_u}%})%"
		formatBuyFruitPickingToolSlot({_p}, 12, {item::crudefruitpicker}, 500, 25, "apple", "{@apple}Apples")
		formatBuyFruitPickingToolSlot({_p}, 13, {item::woodenfruitpicker}, 1000, 50, "pineapple", "{@pineapple}Pineapples", {item::crudefruitpicker})
		formatBuyFruitPickingToolSlot({_p}, 14, {item::fieryfruitpicker}, 2500, 100, "kiwi", "{@kiwi}Kiwis", {item::woodenfruitpicker})
		formatBuyFruitPickingToolSlot({_p}, 15, {item::shinyfruitpicker}, 5000, 150, "peach", "{@peach}Peaches", {item::fieryfruitpicker})
		formatBuyFruitPickingToolSlot({_p}, 16, {item::holyfruitpicker}, 10000, 200, "grape", "{@grape}Grapes", {item::shinyfruitpicker})
	open the last gui to {_p}

function formatBuyFruitPickingToolSlot(p: player, slot: number, item: item, crystalcost: number, fruitcost: number, fruittype: text, fruittext: text, previousitem: item = air):
	set {_u} to uuid of {_p}
	set {_format.item} to {_item}
	set line getLoreLines({_format.item}) + 1 of {_format.item}'s lore to ""
	set line getLoreLines({_format.item}) + 1 of {_format.item}'s lore to "&fCost:"
	set line getLoreLines({_format.item}) + 1 of {_format.item}'s lore to "&8• &d♦%formatmoney({_crystalcost})%"
	set line getLoreLines({_format.item}) + 1 of {_format.item}'s lore to "&8• &7%{_fruitcost}% %colored {_fruittext}%"
	if displayname of {_item} does not contain "Crude":
		set line getLoreLines({_format.item}) + 1 of {_format.item}'s lore to "&8• &7Previous Fruit Picker"
	set line getLoreLines({_format.item}) + 1 of {_format.item}'s lore to ""
	set line getLoreLines({_format.item}) + 1 of {_format.item}'s lore to "&8• &7Click &bhere &7to purchase"
	edit gui with id "fruitpickingtoolmenu-%{_u}%":
		make gui slot {_slot} with {_format.item}:
			if {crystals::%{_u}%} >= {_crystalcost}:
				if {fruit::basket::amount::%{_fruittype}%::%{_u}%} >= {_fruitcost}:
					if {_p} has 1 of {_previousitem}:
						if {_p} can hold 1 of {_item}:
							remove 1 of {_previousitem} from {_p}'s inventory
							give {_p} 1 of {_item}
							subtract {_crystalcost} from {crystals::%{_u}%}
							subtract {_fruitcost} from {fruit::basket::amount::%{_fruittype}%::%{_u}%}
							play sound "entity.arrow.hit_player" at pitch 2 to {_p}
							send "{@prefix} &7You purchased a &f%displayname of {_item}%&7!" to {_p}
							close {_p}'s inventory
						else:
							error({_p}, "You do not have enough inventory space for this!")
					else:
						error({_p}, "You need the previous fruit picker to upgrade!")
				else:
					error({_p}, "Insufficient resources")
			else:
				error({_p}, "Insufficient funds")