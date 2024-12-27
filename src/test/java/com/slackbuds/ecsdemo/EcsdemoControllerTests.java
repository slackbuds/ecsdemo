package com.slackbuds.ecsdemo;

import lombok.extern.log4j.Log4j2;
import org.junit.jupiter.api.Test;

@Log4j2
public class EcsdemoControllerTests {

  @Test
  void testLogging() {
    log.trace("foo");
    log.debug("foo");
    log.info("foo");
    log.warn("foo\\bar");

    try {
      var foo = 42 / 0;
    } catch (Exception e) {
      log.error("foo", e);
    }
  }
}
