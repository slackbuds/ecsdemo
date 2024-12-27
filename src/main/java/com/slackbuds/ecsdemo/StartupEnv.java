package com.slackbuds.ecsdemo;

import jakarta.annotation.PostConstruct;
import java.util.Map;
import lombok.Builder;
import lombok.Getter;
import lombok.extern.log4j.Log4j2;

@Log4j2
@Getter
@Builder
public class StartupEnv {

  private Map<String, String> env;

  @PostConstruct
  void postConstruct() {
    env.forEach((k, v) -> log.debug("{}: {}", k, v));
  }
}
