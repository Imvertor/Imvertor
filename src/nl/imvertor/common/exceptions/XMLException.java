//SVN: $Id: XMLException.java 7165 2015-07-21 12:36:53Z arjan $

package nl.imvertor.common.exceptions;

@SuppressWarnings("serial")
public class XMLException extends Exception {

	public XMLException(Exception e) {
		super(e);
	}
	public XMLException(String e) {
		super(e);
	}
}
