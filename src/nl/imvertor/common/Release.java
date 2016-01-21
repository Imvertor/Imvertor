/*

    Copyright (C) 2016 Dienst voor het kadaster en de openbare registers

*/

/*

    This file is part of Imvertor.

    Imvertor is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Imvertor is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Imvertor.  If not, see <http://www.gnu.org/licenses/>.

*/


// SVN: $Id: Release.java 7369 2016-01-08 15:35:15Z arjan $

package nl.imvertor.common;


/**
 * This class represents the release info on Imvertor.
 *  
 * @author Arjan
 *
 */
public class Release {
	// TODO determine a valid version identifier based on all resources, i.e. java and XSLT 
	
	// change version number manually here, on each adaptation made in the imvertor sources! 
	private static String imvertorVersion = "Imvertor OS 0.63"; // 
	
	private static String imvertorSVNVersion = val("$Id: Release.java 7369 2016-01-08 15:35:15Z arjan $");
	
	public static String getVersion() {
		return imvertorVersion;
	}
	
	public static String getVersionString() {
		return imvertorVersion;
	}
	
	public static String getReleaseString() {
		return imvertorSVNVersion;
	}
	
	private static String val(String svnString) {
		return svnString.substring(svnString.indexOf(" ") + 1, svnString.length() - 2);
	}
}
