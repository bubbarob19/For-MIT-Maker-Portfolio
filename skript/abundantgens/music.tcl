#MUSIC.SK

command /music:
	trigger:
		play sound "entity.chicken.egg" at pitch 0 to player
		musicMenu(player)

function musicMenu(p: player):
	set {_u} to uuid of {_p}
	create a gui with virtual chest inventory with size 4 named "Music Menu":
		make gui slot (integers between 0 and 35) with light gray stained glass pane named "&1"
		make gui slot (integers between 27 and 35) with black stained glass pane named "&1"
		make gui slot 35 with barrier named "&4Close Menu":
			close {_p}'s inventory
			play sound "entity.chicken.egg" at pitch 0 to {_p}
		if {music::status::%{_u}%} is not set:
			make gui slot 10 with lime dye named "&fMusic &8| &a&lON" with lore "&7" and "&8• &7Click to toggle":
				set {music::status::%{_u}%} to false
				stop song with id "%{_u}%-%{music::soundtrack::%{_u}%}%" if song with id "%{_u}%-%{music::soundtrack::%{_u}%}%" is playing
				delete {music::soundtrack::%{_u}%}
				play sound "entity.arrow.hit_player" at pitch 0 to {_p}
				musicMenu({_p})
		else:
			make gui slot 10 with gray dye named "&fMusic &8| &4&lOFF" with lore "&7" and "&8• &7Click to toggle":
				delete {music::status::%{_u}%}
				play sound "entity.arrow.hit_player" at pitch 2 to {_p}
				musicMenu({_p})
		if {music::auto::%{_u}%} is not set:
			make gui slot 11 with lime dye named "&fMusic Auto Changing &8| &a&lON" with lore "&7" and "&8• &7Click to toggle":
				set {music::auto::%{_u}%} to false
				play sound "entity.arrow.hit_player" at pitch 0 to {_p}
				musicMenu({_p})
		else:
			make gui slot 11 with gray dye named "&fMusic Auto Changing &8| &4&lOFF" with lore "&7" and "&8• &7Click to toggle":
				delete {music::auto::%{_u}%}
				play sound "entity.arrow.hit_player" at pitch 2 to {_p}
				musicMenu({_p})
		if {music::soundtrack::%{_u}%} = "general1":
			make gui slot 13 with lime concrete named "&fGeneral ##1" with lore "" and "&8• &7Currently Selected"
		else:
			make gui slot 13 with red concrete named "&fGeneral ##1" with lore "" and "&8• &7Click to select":
				{music::status::%{_u}%} is not set
				musicChange({_p}, "general1")
				musicMenu({_p})
		if {music::soundtrack::%{_u}%} = "warzone":
			make gui slot 14 with lime concrete named "&fWarzone Theme" with lore "" and "&8• &7Currently Selected"
		else:
			make gui slot 14 with red concrete named "&fWarzone Theme" with lore "" and "&8• &7Click to select":
				{music::status::%{_u}%} is not set
				musicChange({_p}, "warzone")
				musicMenu({_p})
		#if {music::soundtrack::%{_u}%} = "nature":
		#	make gui slot 15 with lime concrete named "&fNature Theme" with lore "" and "&8• &7Currently Selected"
		#else:
		#	make gui slot 15 with red concrete named "&fNature Theme" with lore "" and "&8• &7Click to select":
		#		{music::status::%{_u}%} is not set
		#		musicChange({_p}, "nature")
		#		musicMenu({_p})
		make gui slot 15 and 16 with barrier named "&4Coming Soon"
	open the last gui to {_p}

function musicChange(p: player, song: text):
	set {_u} to uuid of {_p}
	set {_oldsong} to ({music::soundtrack::%{_u}%} ? "none")
	set {music::soundtrack::%{_u}%} to {_song}
	stop song with id "%{_u}%-%{_oldsong}%" if song with id "%{_u}%-%{_oldsong}%" is playing
	play new noteblock song song file "plugins/FunkySk/%{_song}%.nbs" to {_p} with id "%{_u}%-%{_song}%" 
	set {_ts} to length of song song file "plugins/FunkySk/%{_song}%.nbs"
	set {_ts} to {_ts} * 2
	if {_song} is "general1":
		set {_ts} to "%{_ts} + 4% ticks" parsed as a timespan
	if {_song} is "warzone":
		set {_ts} to "%{_ts} + 4% ticks" parsed as a timespan
	#if {_song} is "nature":
	#	set {_ts} to "%{_ts} + 10% ticks" parsed as a timespan
	wait {_ts}
	if {music::soundtrack::%{_u}%} = {_song}:
		if song with id "%{_u}%-%{_song}%" is not playing:
			musicChange({_p}, {_song})

on quit:
	stop song with id "%player's uuid%-warzone" if song with id "%player's uuid%-warzone" is playing
	stop song with id "%player's uuid%-general1" if song with id "%player's uuid%-general1" is playing
	#stop song with id "%player's uuid%-nature" if song with id "%player's uuid%-nature" is playing
	delete {music::soundtrack::%player's uuid%}

on player world change:
	{music::status::%player's uuid%} is not set
	{music::auto::%player's uuid%} is not set
	"%event-world%" contains "plots"
	{music::soundtrack::%player's uuid%} is not "general1"
	wait 1 second
	musicChange(player, "general1")

on enter of region:
	{music::status::%player's uuid%} is not set
	{music::auto::%player's uuid%} is not set
	if event-region is "fruit-picking-1" parsed as a region:
		if {music::soundtrack::%player's uuid%} is not "general1":
			wait 10 ticks
			musicChange(player, "general1")
	if event-region is "warzone" parsed as a region:
		if {music::soundtrack::%player's uuid%} is not "warzone":
			wait 10 ticks
			musicChange(player, "warzone")
	if event-region is "farming-1" parsed as a region:
		if {music::soundtrack::%player's uuid%} is not "general1":
			wait 10 ticks
			musicChange(player, "general1")

on join:
	{music::status::%player's uuid%} is not set
	{music::auto::%player's uuid%} is not set
	wait 2 seconds
	if {music::soundtrack::%player's uuid%} is not "general1":
		musicChange(player, "general1")