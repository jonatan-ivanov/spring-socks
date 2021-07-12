package lol.maki.socks.catalog.web;

import java.util.List;

import lol.maki.socks.cart.Cart;
import lol.maki.socks.catalog.CatalogClient;
import lol.maki.socks.catalog.CatalogOrder;
import lol.maki.socks.catalog.client.SockResponse;
import lol.maki.socks.catalog.client.TagsResponse;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import org.springframework.cloud.sleuth.Tracer;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class HomeController {
	private final CatalogClient catalogClient;
	private final Tracer tracer;

	public HomeController(CatalogClient catalogClient, Tracer tracer) {
		this.catalogClient = catalogClient;
		this.tracer = tracer;
	}

	@GetMapping(path = "/")
	public String home(Model model, Cart cart, @RequestParam(value = "devMode", required = false, defaultValue = "true") boolean devMode) {
		this.tracer.currentSpan().tag("devMode", String.valueOf(devMode));

		int requestedSocks = devMode ? 1234567890 : 6;
		final Flux<SockResponse> socks = this.catalogClient.getSocksWithFallback(CatalogOrder.PRICE, 1, requestedSocks, List.of("featured"));
		model.addAttribute("socks", socks);

		final Mono<TagsResponse> tags = this.catalogClient.getTagsWithFallback();
		model.addAttribute("tags", tags);

		return "index";
	}
}
