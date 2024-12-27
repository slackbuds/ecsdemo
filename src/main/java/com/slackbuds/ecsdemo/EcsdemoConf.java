package com.slackbuds.ecsdemo;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class EcsdemoConf {

  @Bean
  StartupEnv startupEnv() {
    return StartupEnv.builder().env(System.getenv()).build();
  }
}
