package lol.maki.socks.catalog.service;

import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

import javax.validation.constraints.NotNull;

import lol.maki.socks.catalog.Sock;
import lol.maki.socks.catalog.repo.SocksRepository;

import org.springframework.stereotype.Service;

@Service
public class SocksService {
	private final SocksRepository repository;

	public SocksService(SocksRepository repository) {
		this.repository = repository;
	}

	@NotNull
	public Iterable<Sock> findAllById(@NotNull Iterable<String> ids) {
		return StreamSupport.stream(ids.spliterator(), false)
				.map(repository::findById)
				.flatMap(Optional::stream)
				.collect(Collectors.toUnmodifiableList());
	}
}
