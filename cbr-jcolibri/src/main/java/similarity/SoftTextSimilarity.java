package similarity;

import java.text.Normalizer;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

import es.ucm.fdi.gaia.jcolibri.exception.NoApplicableSimilarityFunctionException;
import es.ucm.fdi.gaia.jcolibri.method.retrieve.NNretrieval.similarity.LocalSimilarityFunction;

public class SoftTextSimilarity implements LocalSimilarityFunction {

    private final Map<String, String> canonicalMap = new HashMap<>();

    public void addSynonyms(String canonical, String... variants) {
        String canon = normalize(canonical);
        canonicalMap.put(canon, canon);
        for (String variant : variants) {
            canonicalMap.put(normalize(variant), canon);
        }
    }

    @Override
    public double compute(Object value1, Object value2) throws NoApplicableSimilarityFunctionException {
        if (!(value1 instanceof String) || !(value2 instanceof String)) {
            return 0;
        }
        return compute((String) value1, (String) value2);
    }

    public double compute(String value1, String value2) {
        String left = normalize(value1);
        String right = normalize(value2);

        if (isUnknown(left) || isUnknown(right)) {
            return 0.2;
        }

        if (left.equals(right)) {
            return 1.0;
        }

        String leftCanon = canonicalMap.getOrDefault(left, left);
        String rightCanon = canonicalMap.getOrDefault(right, right);
        if (leftCanon.equals(rightCanon)) {
            return 0.9;
        }

        double tokenJaccard = tokenJaccard(left, right);
        double charDice = charBigramDice(left, right);
        return Math.max(tokenJaccard, charDice * 0.9);
    }

    @Override
    public boolean isApplicable(Object value1, Object value2) {
        return value1 instanceof String && value2 instanceof String;
    }

    private boolean isUnknown(String value) {
        return value == null || value.isEmpty() || "unknown".equals(value) || "nepoznato".equals(value);
    }

    private String normalize(String value) {
        if (value == null) {
            return "unknown";
        }
        String ascii = Normalizer.normalize(value, Normalizer.Form.NFD)
                .replaceAll("\\p{M}+", "")
                .toLowerCase(Locale.ROOT)
                .trim();
        ascii = ascii.replaceAll("\\s+", " ");
        if (ascii.isEmpty()) {
            return "unknown";
        }
        return ascii;
    }

    private double tokenJaccard(String left, String right) {
        Set<String> leftTokens = new HashSet<String>();
        Set<String> rightTokens = new HashSet<String>();

        for (String token : left.split(" ")) {
            if (!token.isEmpty()) {
                leftTokens.add(token);
            }
        }
        for (String token : right.split(" ")) {
            if (!token.isEmpty()) {
                rightTokens.add(token);
            }
        }

        if (leftTokens.isEmpty() || rightTokens.isEmpty()) {
            return 0.0;
        }

        int intersection = 0;
        for (String token : leftTokens) {
            if (rightTokens.contains(token)) {
                intersection++;
            }
        }

        int union = leftTokens.size() + rightTokens.size() - intersection;
        if (union == 0) {
            return 0.0;
        }
        return (double) intersection / union;
    }

    private double charBigramDice(String left, String right) {
        Set<String> leftBigrams = bigrams(left);
        Set<String> rightBigrams = bigrams(right);

        if (leftBigrams.isEmpty() || rightBigrams.isEmpty()) {
            return 0.0;
        }

        int intersection = 0;
        for (String gram : leftBigrams) {
            if (rightBigrams.contains(gram)) {
                intersection++;
            }
        }

        return (2.0 * intersection) / (leftBigrams.size() + rightBigrams.size());
    }

    private Set<String> bigrams(String value) {
        Set<String> result = new HashSet<String>();
        String normalized = value.replace(" ", "");
        if (normalized.length() < 2) {
            return result;
        }
        for (int i = 0; i < normalized.length() - 1; i++) {
            result.add(normalized.substring(i, i + 2));
        }
        return result;
    }
}
