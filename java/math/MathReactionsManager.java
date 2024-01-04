package net.abundantmc.pvp.math;

import net.abundantmc.abundantlibrary.spigotlibrary.utilities.AudienceUtils;
import net.abundantmc.pvp.AbundantPlugin;
import net.abundantmc.pvp.math.mathquestions.MathQuestion;
import org.bukkit.plugin.Plugin;
import org.bukkit.scheduler.BukkitRunnable;

public class MathReactionsManager {
    private static MathReactionsManager instance;

    private final MathProblemGenerator generator = MathProblemGenerator.getInstance();
    private final Plugin plugin = AbundantPlugin.getPlugin();
    private BukkitRunnable mathReactionsRunnable;
    private boolean runnableRunning;
    private boolean inMathQuestion;
    private MathQuestion currentQuestion;
    private long startTimeMs;

    public static MathReactionsManager getInstance() {
        if (instance == null)
            instance = new MathReactionsManager();
        return instance;
    }

    private MathReactionsManager() {
        createRunnable();
        startRunnable(15 * 60, 5 * 60 * 20);
    }

    private void createRunnable() {
        mathReactionsRunnable = new BukkitRunnable() {
            @Override
            public void run() {
                if (!inMathQuestion) {
                    inMathQuestion = true;
                    currentQuestion = generator.generateRandomMathQuestion();
                    startTimeMs = System.currentTimeMillis();
                }
                AudienceUtils.sendMsg(AudienceUtils.ofAllPlayers(),
                        "",
                        "<aqua><b>MATH QUESTION<!b> <gray>(Type your answer as a whole number if possible, fraction or decimal if not)",
                        "<gray>The first person to answer wins a reward!",
                        "<dot> <white>Solve: <aqua>" + currentQuestion.getProblem(),
                        ""
                );
            }
        };
    }

    public void startRunnable(int secondsPerQuestion, int delayInTicks) {
        if (mathReactionsRunnable != null)
            endRunnable();
        createRunnable();

        int timeInTicks = secondsPerQuestion * 20;
        mathReactionsRunnable.runTaskTimer(plugin, delayInTicks, timeInTicks);
        runnableRunning = true;
    }

    public void endRunnable() {
        if (runnableRunning)
            mathReactionsRunnable.cancel();
        runnableRunning = false;
        endCurrentMathQuestion();
    }

    public boolean isInMathQuestion() {
        return inMathQuestion;
    }

    public boolean checkPlayerAnswer(String answer) {
        if (currentQuestion == null)
            return false;

        return currentQuestion.checkAnswer(answer);
    }

    public void endCurrentMathQuestion() {
        currentQuestion = null;
        inMathQuestion = false;
    }

    public long getStartTimeMs() {
        return startTimeMs;
    }
}
