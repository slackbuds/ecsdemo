package com.slackbuds.ecsdemo;

import java.util.Map;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class EchoResponse {

  private Map<String, String> headers;
  private String body;
}
