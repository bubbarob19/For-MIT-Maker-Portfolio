package net.abundantmc.pvp.math.mathquestions;

public class PolynomialDerivative implements MathQuestion {
    private int[] terms;
    private int xValue;
    private int answer;

    public PolynomialDerivative(int[] terms) {
        this.terms = terms;
    }

    public PolynomialDerivative() {
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
        xValue = (int) (Math.random() * 11) - 5;
        calculateAnswer();
    }

    private void calculateAnswer() {
        answer = 0;
        // Ignore last term: it is a constant
        for (int i = 0; i < terms.length - 1; i++) {
            int oldExponent = terms.length - 1 - i;
            int newExponent = oldExponent - 1;
            answer += (int) (Math.pow(xValue, newExponent)) * oldExponent * terms[i];
        }
    }

    @Override
    public boolean checkAnswer(String userInput) {
        try {
            return (Integer.parseInt(userInput) == answer);
        } catch (Exception e) {
            return false;
        }
    }

    @Override
    public String getProblem() {
        StringBuilder stringBuilder = new StringBuilder();

        stringBuilder.append("d/dx (");
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
        stringBuilder.append(") at x = ")
                .append(xValue);

        return stringBuilder.toString();
    }
}
