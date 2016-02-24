// SVN: $Id: GetUUID.java 533 2015-01-14 13:57:41Z arjan $

package nl.imvertor.common.xsl.extensions;

/*
 * return the current datetime in milliseconds 
 * or parse a standard datetime string and return millis.
 * 
 */
import java.util.UUID;

import net.sf.saxon.expr.XPathContext;
import net.sf.saxon.lib.ExtensionFunctionCall;
import net.sf.saxon.om.Sequence;
import net.sf.saxon.om.StructuredQName;
import net.sf.saxon.trans.XPathException;
import net.sf.saxon.value.SequenceType;
import net.sf.saxon.value.StringValue;
import nl.imvertor.common.Configurator;

public class ImvertorGetUUID extends net.sf.saxon.lib.ExtensionFunctionDefinition {

	private static final StructuredQName qName = new StructuredQName("", Configurator.NAMESPACE_EXTENSION_FUNCTIONS, "imvertorGetUUID");

	public StructuredQName getFunctionQName() {
		return qName;
	}

	public int getMinimumNumberOfArguments() {
		return 0;
	}

	public int getMaximumNumberOfArguments() {
		return 0;
	}

	public SequenceType[] getArgumentTypes() {
		return new SequenceType[] { };
	}

	public SequenceType getResultType(SequenceType[] suppliedArgumentTypes) {
		return SequenceType.SINGLE_STRING;
	}

	public ExtensionFunctionCall makeCallExpression() {
		return new GetUUIDCall();
	}

	private static class GetUUIDCall extends ExtensionFunctionCall {

		@Override
	    public StringValue call(XPathContext context, Sequence[] arguments) throws XPathException {
			UUID uuid = UUID.randomUUID();
			//	String variableName = ((StringValue) arguments[0].next()).getStringValue();
			return StringValue.makeStringValue(uuid.toString());
		}
	}
}