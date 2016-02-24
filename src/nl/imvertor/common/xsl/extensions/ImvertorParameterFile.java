//SVN: $Id: ImvertorParameterFile.java 7265 2015-09-17 11:14:19Z arjan $

package nl.imvertor.common.xsl.extensions;

/*
* Access the Imvertor configuration. 
* 
* This reads and writes configuration parameters, and saves a configuration to the file.
* Note that this concerns the "work" configuration file, not "any" configuration file; so load() is not provided.
*  
*/
import net.sf.saxon.expr.XPathContext;
import net.sf.saxon.lib.ExtensionFunctionCall;
import net.sf.saxon.lib.ExtensionFunctionDefinition;
import net.sf.saxon.om.Sequence;
import net.sf.saxon.om.StructuredQName;
import net.sf.saxon.trans.XPathException;
import net.sf.saxon.value.EmptySequence;
import net.sf.saxon.value.SequenceType;
import net.sf.saxon.value.StringValue;
import nl.imvertor.common.Configurator;
import nl.imvertor.common.Transformer;

public class ImvertorParameterFile extends ExtensionFunctionDefinition {

	private static final StructuredQName qName = new StructuredQName("", Configurator.NAMESPACE_EXTENSION_FUNCTIONS, "imvertorParameterFile");

	public StructuredQName getFunctionQName() {
		return qName;
	}

	public int getMinimumNumberOfArguments() {
		return 4;
	}

	public int getMaximumNumberOfArguments() {
		return 4;
	}

	public SequenceType[] getArgumentTypes() {
		return new SequenceType[] { 
				SequenceType.SINGLE_STRING,
				SequenceType.OPTIONAL_STRING,
				SequenceType.OPTIONAL_STRING,
				SequenceType.OPTIONAL_STRING,
				};
	}

	public SequenceType getResultType(SequenceType[] suppliedArgumentTypes) {
		return SequenceType.ANY_SEQUENCE;
	}

	public ExtensionFunctionCall makeCallExpression() {
		return new ImvertorParameterFileCall();
	}

	private static class ImvertorParameterFileCall extends ExtensionFunctionCall {

		public Sequence call(XPathContext context, Sequence[] arguments) throws XPathException {

			try {
				if (arguments.length != 4)
					throw new Exception("Invalid number of arguments: " + arguments.length);
				
				String operationType = Transformer.getStringvalue(arguments[0]);
				String variableGroup = Transformer.getStringvalue(arguments[1]);
				String variableName = Transformer.getStringvalue(arguments[2]);
				String variableValue = Transformer.getStringvalue(arguments[3]);
				
				switch (operationType) {
					case "GET": // get a parameter by name
						String v = Configurator.getInstance().getParm(variableGroup, variableName, false);
						if (v == null) return EmptySequence.getInstance();
						else return StringValue.makeStringValue(v);
					case "SET": // set a parameter value
						Configurator.getInstance().setParm(variableGroup,variableName,variableValue);
						return EmptySequence.getInstance();
					case "SAVE": // write map to disk
						Configurator.getInstance().save();
						return EmptySequence.getInstance();
					case "REMOVE": // remove a paramter
						Configurator.getInstance().removeParm(variableGroup, variableName);
						return EmptySequence.getInstance();
					default:
						throw new XPathException("Invalid parameter operation: " + operationType);
				}
			} catch (Exception e) {
				throw new XPathException(e);
			}
		}
		
	}
}
