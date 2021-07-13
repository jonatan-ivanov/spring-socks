package lol.maki.socks;

import lol.maki.socks.catalog.SockNotFoundException;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class SocksPoller {
	@Scheduled(fixedRate = 10_000)
	public void pollSocks() {
		throw SockNotFoundException.ignoreMe();
	}
}