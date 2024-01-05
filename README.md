# MIT Maker Portfolio Extra Information:
Hello there! I made this repository specifically to share some old code and extra links that you might find useful! This is just a small collection of some of the things I have done with my Minecraft servers over the past 4 years.

Sadly, I cannot show you much code from the server I am currently working on, as we keep all of that private. We do this because players can look at public code and search for exploits to break the server. However, I have plenty of code from old servers and some code from my newest project that shouldn't cause any major exploits if viewed by the public. I have worked with other developers on my servers, but any code you see in this repository was made solely by me!

## Skripts

Skripts are how I used to code my old servers before I got into Java! I placed many of my old skripts in this repository for you to view.

## Java

I have some snippets of old (and some new) code that you can view. I added a few folders with different features I made, and put some relevant / interesting classes in them with a short description. All of the code I am showing you are just small parts of much larger projects with 50-200 classes of code.

Also, note! You may see some things considered "bad practice" in typical software engineering. There are a couple reasons for this:
- Some of the code is a couple years old (I was very bad at first)
- The Minecraft Server APIs I use do not natively support things like dependency injection. You can add it with external libraries like Guice, but it is truly a pain, and not worth it for most Minecraft plugins. Static singletons may be ugly, but they sure do save time!
- Velocity is almost always prioritized over clean code for server development
  - Quick story: at one point, I spent a whole lot of time trying to make multiple microservices for one of my servers. It was a great learning experience, but extremely unnecessary for the project I was working on - connecting to the MongoDB driver itself is way easier. I ended up scrapping the microservices at the end anyways since it was too clunky and annoying to manage. 

## Helpful Links for context:

If you want to know more about what exactly a Minecraft Server is or what my servers are like, here is a great video of one of my old servers (Abundant Gens) made by one of our media partners. It's unlisted now since this particular game mode is no longer online, but it gives a great overview of the generator game mode I created and will give you insight into what a Minecraft server looks like.

- https://www.youtube.com/watch?v=OuLtjYn8N-0
 
Along with this, here is a clip of Minehut trying out my submission for the Minehut Hackathon. The link should send you to the correct timestamp, but if it doesn't, the clip starts 35 minutes and 9 seconds into the video. Buick (the other owner of this server) and I created a fun obstacle course game mode based on the TV show Wipeout. At the beginning, you will even hear a custom Wipeout theme song I created using [NoteBlockAPI](https://github.com/koca2000/NoteBlockAPI)!

- https://www.youtube.com/watch?v=O2N1xzvC5pM&t=2109s
