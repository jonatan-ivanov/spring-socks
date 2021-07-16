package lol.maki.socks;

import lol.maki.socks.catalog.SockNotFoundException;

import org.springframework.stereotype.Component;

@Component
public class SocksPoller {
//	@Scheduled(fixedRate = 30_000)
	public void socksPollerIgnoreMe() {
		throw SockNotFoundException.ignoreMe();
	}
}