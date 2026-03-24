package similarity;

import java.util.Locale;

import es.ucm.fdi.gaia.jcolibri.exception.NoApplicableSimilarityFunctionException;
import es.ucm.fdi.gaia.jcolibri.method.retrieve.NNretrieval.similarity.LocalSimilarityFunction;

public class UnknownAwareBooleanSimilarity implements LocalSimilarityFunction {

    @Override
    public double compute(Object value1, Object value2) throws NoApplicableSimilarityFunctionException {
        if (!(value1 instanceof String) || !(value2 instanceof String)) {
            return 0.0;
        }
        return compute((String) value1, (String) value2);
    }

    public double compute(String value1, String value2) {
        String left = normalize(value1);
        String right = normalize(value2);

        if ("unknown".equals(left) || "unknown".equals(right)) {
            return 0.5;
        }
        return left.equals(right) ? 1.0 : 0.0;
    }

    @Override
    public boolean isApplicable(Object value1, Object value2) {
        return value1 instanceof String && value2 instanceof String;
    }

    private String normalize(String value) {
        if (value == null) {
            return "unknown";
        }
        String normalized = value.trim().toLowerCase(Locale.ROOT);
        if (normalized.isEmpty() || "null".equals(normalized) || "unknown".equals(normalized)) {
            return "unknown";
        }
        if ("true".equals(normalized) || "1".equals(normalized) || "yes".equals(normalized) || "da".equals(normalized)) {
            return "true";
        }
        if ("false".equals(normalized) || "0".equals(normalized) || "no".equals(normalized) || "ne".equals(normalized)) {
            return "false";
        }
        return "unknown";
    }
}
