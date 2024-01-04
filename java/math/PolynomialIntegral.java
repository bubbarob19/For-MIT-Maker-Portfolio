package net.abundantmc.pvp.math.mathquestions;

import java.math.BigDecimal;
import java.math.RoundingMode;
public class PolynomialIntegral implements MathQuestion {
    private int[] terms;
    private int upperBound;
    private int lowerBound;
    private double answer;

    public PolynomialIntegral(int[] terms) {
        this.terms = terms;
    }

    public PolynomialIntegral() {
        randomizeConstants();
    }

    @Override
    public void randomizeConstants() {
        int numberOfTerms = (int) (Math.random() * 5) + 1;
        terms = new int[numberOfTerms];
        for (int i = 0; i < terms.length; i++) {
            int constant = (int) (Math.random() * 10) + 1;
            terms[i] = constant;
        }
        upperBound = (int) (Math.random() * 5) + 1;
        lowerBound = (int) (Math.random() * upperBound);
        calculateAnswer();
    }

    private void calculateAnswer() {
        answer = 0;
        for (int i = 0; i < terms.length; i++) {
            double oldExponent = terms.length - 1 - i;
            double newExponent = oldExponent + 1;
            answer += Math.pow(upperBound, newExponent) / newExponent * terms[i];
            answer -= Math.pow(lowerBound, newExponent) / newExponent * terms[i];
        }
        answer = round(answer, 2);
    }

    @Override
    public boolean checkAnswer(String userInput) {
        double parsed = 0;
        if (userInput.contains("/")) {
            String[] split = userInput.split("/");
            try {
                int numerator = Integer.parseInt(split[0]);
                int denominator = Integer.parseInt(split[1]);
                parsed = (double) numerator / denominator;
            } catch (Exception e) {
                return false;
            }
        } else if (userInput.contains(".")) {
            try {
                parsed = Double.parseDouble(userInput);
            } catch (NumberFormatException exception) {
                return false;
            }
        } else {
            try {
                parsed = Double.parseDouble(userInput + ".0");
            } catch (NumberFormatException exception) {
                return false;
            }
        }

        return (round(parsed, 2) == answer);
    }

    public static double round(double value, int places) {
        BigDecimal bd = BigDecimal.valueOf(value);
        bd = bd.setScale(places, RoundingMode.HALF_UP);
        return bd.doubleValue();
    }

    @Override
    public String getProblem() {
        StringBuilder stringBuilder = new StringBuilder();

        stringBuilder.append("∫(");
        for (int i = 0; i < terms.length; i++) {
            int exponent = terms.length - 1 - i;
            if (i != 0)
                stringBuilder.append(terms[i] > 0 ? " + " : " - ");
            else if (terms[i] < 0)
                stringBuilder.append("- ");

            stringBuilder.append(terms[i]);
            if (exponent > 1)
                stringBuilder.append("x^")
                        .append(exponent);
            else if (exponent == 1)
                stringBuilder.append("x");
        }
        stringBuilder.append(")dx from x = ")
                .append(lowerBound)
                .append(" to ")
                .append(upperBound);

        return stringBuilder.toString();
    }
}
