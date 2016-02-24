//SVN: $Id: ImvertorZipDeserializer.java 7295 2015-11-04 11:24:37Z arjan $

package nl.imvertor.common.xsl.extensions;

import net.sf.saxon.expr.XPathContext;
import net.sf.saxon.lib.ExtensionFunctionCall;
import net.sf.saxon.lib.ExtensionFunctionDefinition;
import net.sf.saxon.om.Sequence;
import net.sf.saxon.om.StructuredQName;
import net.sf.saxon.trans.XPathException;
import net.sf.saxon.value.SequenceType;
import net.sf.saxon.value.StringValue;
import nl.imvertor.common.Configurator;
import nl.imvertor.common.Transformer;
import nl.imvertor.common.file.AnyFolder;
import nl.imvertor.common.file.ZipFile;

/**
* Saxon Extension function that deserializes serialized zsip-folder to a zip file.
* The arguments are 1/ the folder to re-pack to zip, and 2/ the (relative) path of the result zip file. 
* The extension function returns the full path to the zip file.
* 
* @author arjan
*
*/
public class ImvertorZipDeserializer extends ExtensionFunctionDefinition {

	private static final StructuredQName qName = new StructuredQName("", Configurator.NAMESPACE_EXTENSION_FUNCTIONS, "imvertorZipDeserializer");

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
		return new SequenceType[] { 
				SequenceType.SINGLE_STRING,
				SequenceType.SINGLE_STRING
		};
	}

	public SequenceType getResultType(SequenceType[] suppliedArgumentTypes) {
		return SequenceType.STRING_SEQUENCE;
	}

	public ExtensionFunctionCall makeCallExpression() {
		return new ImvertorZipDeserializerCall();
	}

	private static class ImvertorZipDeserializerCall extends ExtensionFunctionCall {

		public Sequence call(XPathContext context, Sequence[] arguments) throws XPathException {

			try {
				String folderpath = Transformer.getStringvalue(arguments[0]);
				String filepath = Transformer.getStringvalue(arguments[1]);
				if (filepath.startsWith("file:/")) filepath = filepath.substring(6);
				if (folderpath.startsWith("file:/")) folderpath = folderpath.substring(6);
				AnyFolder serializeFolder = new AnyFolder(folderpath);
				ZipFile zipFile = new ZipFile(filepath);
			    zipFile.deserializeFromXml(serializeFolder,true);
				return StringValue.makeStringValue(zipFile.getAbsolutePath());
			} catch (Exception e) {
				throw new XPathException(e);
			}
		}
		
	}
}
//