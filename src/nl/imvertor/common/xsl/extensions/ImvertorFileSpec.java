//SVN: $Id: ImvertorFileSpec.java 7265 2015-09-17 11:14:19Z arjan $

package nl.imvertor.common.xsl.extensions;

import net.sf.saxon.expr.XPathContext;
import net.sf.saxon.lib.ExtensionFunctionCall;
import net.sf.saxon.lib.ExtensionFunctionDefinition;
import net.sf.saxon.om.Sequence;
import net.sf.saxon.om.StructuredQName;
import net.sf.saxon.om.ZeroOrMore;
import net.sf.saxon.trans.XPathException;
import net.sf.saxon.value.SequenceType;
import net.sf.saxon.value.StringValue;
import nl.imvertor.common.Configurator;
import nl.imvertor.common.Transformer;
import nl.imvertor.common.file.AnyFile;

/**
 * Saxon Extension function that returns a list of strings representing information on a file.
 *  
 * @author arjan
 *
 */
public class ImvertorFileSpec extends ExtensionFunctionDefinition {

	private static final StructuredQName qName = new StructuredQName("", Configurator.NAMESPACE_EXTENSION_FUNCTIONS, "imvertorFileSpec");

	public StructuredQName getFunctionQName() {
		return qName;
	}

	public int getMinimumNumberOfArguments() {
		return 1;
	}

	public int getMaximumNumberOfArguments() {
		return 1;
	}

	public SequenceType[] getArgumentTypes() {
		return new SequenceType[] { 
			SequenceType.SINGLE_STRING
			};
	}

	public SequenceType getResultType(SequenceType[] suppliedArgumentTypes) {
		return SequenceType.STRING_SEQUENCE;
	}

	public ExtensionFunctionCall makeCallExpression() {
		return new ImvertorFileSpecCall();
	}

	private static class ImvertorFileSpecCall extends ExtensionFunctionCall {

		public Sequence call(XPathContext context, Sequence[] arguments) throws XPathException {

			try {
				String filepath = Transformer.getStringvalue(arguments[0]);
				if (filepath.startsWith("file:/"))
					filepath = filepath.substring(6);
				String[] spec = (new AnyFile(filepath)).getFilespec();
				StringValue[] values = new StringValue[spec.length];
				for (int i = 0; i < spec.length; i++) 
					values[i] = new StringValue(spec[i]);
			    return new ZeroOrMore<StringValue>(values);
				
			} catch (Exception e) {
				throw new XPathException(e);
			}
		}
		
	}
}
