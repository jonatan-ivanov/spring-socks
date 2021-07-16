package lol.maki.socks.catalog.repo;

import java.util.Optional;

import javax.validation.constraints.NotNull;

import lol.maki.socks.catalog.Sock;

import org.springframework.stereotype.Repository;

@Repository
public class SocksRepository {
	@NotNull
	public Optional<Sock> findById(@NotNull String id) {
		return Optional.empty();
	}
}
