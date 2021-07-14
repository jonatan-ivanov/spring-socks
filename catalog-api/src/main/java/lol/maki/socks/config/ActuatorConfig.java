package lol.maki.socks.config;

import io.micrometer.core.aop.TimedAspect;
import io.micrometer.core.instrument.MeterRegistry;
import io.micrometer.core.instrument.config.MeterFilter;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ActuatorConfig {
	@Bean
	public MeterFilter customMeterFilter() {
		return MeterFilter.deny(id -> {
			String uri = id.getTag("uri");
			return uri != null && (uri.startsWith("/actuator") || uri.startsWith("/cloudfoundryapplication"));
		});
	}

	@Bean
	public TimedAspect timedAspect(MeterRegistry registry) {
		return new TimedAspect(registry);
	}
}
