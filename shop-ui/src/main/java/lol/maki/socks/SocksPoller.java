package lol.maki.socks;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import lol.maki.socks.catalog.CatalogClient;
import lol.maki.socks.catalog.SockNotFoundException;
import org.slf4j.LoggerFactory;

import org.springframework.stereotype.Component;

@Component
public class SocksPoller {
	private final List<Runnable> logTasks = Arrays.asList(
			this::printSocksLogo,
			this::oneTwoThree,
			this::fooBar,
			this::shouldWork,
			this::shouldNotBeCalled
	);

	public static void main(String[] args) {
		new SocksPoller().socksPoller();
	}

//	@Scheduled(fixedRate = 10_000)
	public void socksPollerIgnoreMe() {
		throw SockNotFoundException.ignoreMe();
	}

//	@Scheduled(fixedRate = 5_000)
	public void socksPoller() {
		Collections.shuffle(logTasks);
		logTasks.forEach(Runnable::run);
	}


	private void oneTwoThree() {
		LoggerFactory.getLogger(ShopUiApplication.class).info("1...2...3...");
	}

	private void fooBar() {
		LoggerFactory.getLogger(ShopUiApplication.class).info("Foo Bar");
	}

	private void shouldWork() {
		LoggerFactory.getLogger(CatalogClient.class).info("This should work...");
	}

	private void shouldNotBeCalled() {
		LoggerFactory.getLogger(ShopUiApplication.class).info("This should not be called!");
	}

	private void printSocksLogo() {
		System.out.println("\n"
				+ "   _____            _                _____            _        \n"
				+ "  / ____|          (_)              / ____|          | |       \n"
				+ " | (___  _ __  _ __ _ _ __   __ _  | (___   ___   ___| | _____ \n"
				+ "  \\___ \\| '_ \\| '__| | '_ \\ / _` |  \\___ \\ / _ \\ / __| |/ / __|\n"
				+ "  ____) | |_) | |  | | | | | (_| |  ____) | (_) | (__|   <\\__ \\\n"
				+ " |_____/| .__/|_|  |_|_| |_|\\__, | |_____/ \\___/ \\___|_|\\_\\___/\n"
				+ "        | |                  __/ |                             \n"
				+ "        |_|                 |___/                              \n"
				+ "\n");
	}
}