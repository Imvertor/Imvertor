// SVN: $Id: ImvertorSetVariable.java 7230 2015-09-02 12:32:06Z arjan $

package nl.imvertor.XsdCompiler.xsl.extensions;

import java.util.HashMap;

import net.sf.saxon.expr.XPathContext;
import net.sf.saxon.lib.ExtensionFunctionCall;
import net.sf.saxon.lib.ExtensionFunctionDefinition;
import net.sf.saxon.om.Sequence;
import net.sf.saxon.om.StructuredQName;
import net.sf.saxon.trans.XPathException;
import net.sf.saxon.value.SequenceType;
import net.sf.saxon.value.StringValue;
import nl.imvertor.common.Configurator;

public class ImvertorSetVariable extends ExtensionFunctionDefinition {

	private static final StructuredQName qName = new StructuredQName("", Configurator.NAMESPACE_EXTENSION_FUNCTIONS, "imvertorSetVariable");

	public StructuredQName getFunctionQName() {
		return qName;
	}

	public int getMinimumNumberOfArguments() {
		return 2;
	}

	public int getMaximumNumberOfArguments() {
		return 2;
	}

	public SequenceType[] getArgumentTypes() {
		return new SequenceType[] { SequenceType.SINGLE_STRING, SequenceType.SINGLE_STRING };
	}

	public SequenceType getResultType(SequenceType[] suppliedArgumentTypes) {
		return SequenceType.SINGLE_STRING;
	}

	public ExtensionFunctionCall makeCallExpression() {
		return new SetVariableCall();
	}

	private static class SetVariableCall extends ExtensionFunctionCall {

		@SuppressWarnings("unchecked")
		@Override
	    public StringValue call(XPathContext context, Sequence[] arguments) throws XPathException {
			HashMap<String,String> variableMap = (HashMap<String,String>) context.getController().getUserData("variableMap", "variableMap");
			if (variableMap == null) {
				variableMap = new HashMap<String,String>();
				context.getController().setUserData("variableMap", "variableMap", variableMap);
			}     
			String variableName = ((StringValue) arguments[0].head()).getStringValue();
			String variableVal = ((StringValue) arguments[1].head()).getStringValue();
			variableMap.put(variableName, variableVal);
			return StringValue.makeStringValue("");
		}
	}
}