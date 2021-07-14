package lol.maki.socks;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.UUID;

import static java.nio.file.StandardOpenOption.APPEND;
import static java.nio.file.StandardOpenOption.CREATE;

public class SocksGen {
	private static final Path DESCRIPTION_FILE = Path.of("long-description.txt");
	private static final Path MIGRATION_FILE = Path.of("catalog-api/src/main/resources/db/migration/V5__add_looong_socks.sql");
	private static final String SOCKS_CREATE_FORMAT = "INSERT INTO sock VALUES (\"%s\", \"SpringTest\", \"%s\", 1000.0, 1, \"/images/spring_socks_1.jpg\", \"/images/spring_socks_2.jpg\");\n";
	private static final String SOCKS_TAG_FORMAT = "INSERT INTO sock_tag VALUES (\"%s\", 12);\n";

	public static void main(String[] args) throws IOException {
		Files.deleteIfExists(MIGRATION_FILE);
		Files.writeString(MIGRATION_FILE, "", CREATE);

		String lipsum = Files.readString(DESCRIPTION_FILE);
		String description = "";
		for (int i = 0; i < 200; i++) {
			description += lipsum;
		}

		for (int i = 0; i < 5; i++) {
			String id = UUID.randomUUID().toString();

			String createQuery = String.format(SOCKS_CREATE_FORMAT, id, description);
			Files.writeString(MIGRATION_FILE, createQuery, APPEND);

			String tagQuery = String.format(SOCKS_TAG_FORMAT, id);
			Files.writeString(MIGRATION_FILE, tagQuery, APPEND);
		}
	}
}

