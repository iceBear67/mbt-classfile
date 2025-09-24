public class ControlFlow {
	public static void reallyIHaveToControlYou(int p) { // avoid my boring conditions being folded
		do {
			int i =p;
			int i2 =p*p;
			if (i > i2){
				break;
			}
			p = i2;
		}while( p < 90);
	}
}
