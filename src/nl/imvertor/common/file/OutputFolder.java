package nl.imvertor.common.file;

import java.io.File;
import java.io.IOException;

import org.apache.commons.io.FileUtils;

public class OutputFolder extends AnyFolder {

	private static final long serialVersionUID = 734463381893479052L;

	public OutputFolder(File file) {
		super(file);
	}
	
	public OutputFolder(String path) {
		super(path);
	}

	/**
	 * Clear the complete folder, removing all subfiles and -folders.
	 * This is only allowed when the sentinel file _output is found in the root of the folder.
	 * If this is not the case, throw Exception.
	 * 
	 * @param safe
	 * @throws IOException
	 */
	public void clear(boolean safe) throws IOException {
		File sentinel = new File(this, "_output");
		boolean sentinelExists = sentinel.exists();
		if (isDirectory())
			if (!safe || sentinelExists) {
				try {
					FileUtils.deleteQuietly(this);
					this.mkdir();
					if (sentinelExists) sentinel.createNewFile();
				} catch (Exception e) {
					throw new IOException("Folder cannot be cleared: " + this.getAbsolutePath() + ", because: " + e.getMessage());
				}
			} else
				throw new IOException("Folder cannot be cleared, as no marker file \"_output\" was found: " + this.getAbsolutePath());
		else
			throw new IOException("Folder cannot be cleared, as it doesn't exist: " + this.getAbsolutePath());
	}
	
	public void clearIfExists(boolean safe) throws IOException {
		if (exists()) clear(safe); 
	}
}
