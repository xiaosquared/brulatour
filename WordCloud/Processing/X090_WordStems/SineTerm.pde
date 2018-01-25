public class SineTerm {
  private float amplitude;
  private float waveLength;
  private float phaseDifference;

  public SineTerm(float amplitude, float waveLength, float phaseDifference) {
    this.amplitude = amplitude;
    this.waveLength = waveLength;
    this.phaseDifference = phaseDifference;
  }

  public float evaluate(float x) {
    return amplitude * (float) Math.sin(2 * Math.PI * x / waveLength + phaseDifference);
  }
}