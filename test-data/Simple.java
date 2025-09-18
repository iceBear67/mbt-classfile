import java.util.function.Consumer;

public class Simple<G> {
	// access modifiers
	private String _pri;
	public String _pub;
	protected String _prot;
	String _def;
	int i;
	double d;
	float f;
	long l;
	char ch;
	boolean bl;
	short s;
	byte b;
	G g;

	final String finalStr = "";


	public <T extends CharSequence> void methodPublicVoid(T g){}
	private G methodPrivateString(){ return null; }
	public <T, OtherParam> void justGeneric(T t){}
	public void wildcard(Class<? extends CharSequence> clazz){}

	public Simple(){ // constructor
	}
}
