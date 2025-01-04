package com.slackbuds.ecsdemo;

import java.util.List;
import java.util.Map;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import software.amazon.awssdk.services.dynamodb.DynamoDbClient;

@Log4j2
@RestController
@RequestMapping("/api/v1")
public class EcsdemoController {

  private final StartupEnv startupEnv;
  private final DynamoDbClient dynamoDbClient;

  EcsdemoController(StartupEnv startupEnv,
      DynamoDbClient dynamoDbClient) {
    this.startupEnv = startupEnv;
    this.dynamoDbClient = dynamoDbClient;
  }

  @GetMapping("hello")
  ResponseEntity<String> getHelloWorld(@RequestParam(value = "name", defaultValue = "World") String name) {
    log.debug("hello called by {}", name);

    return new ResponseEntity<>(
        String.format("Hello %s!", name),
        HttpStatus.OK);
  }

  @GetMapping(value = "env")
  ResponseEntity<String> getEnvPlain(@RequestParam(value = "key", defaultValue = "") String key) {
    log.debug("get startup env \"{}\" as plain", key);

    var res = "";
    if (key.isBlank()) {
      StringBuilder sb = new StringBuilder();
      startupEnv.getEnv().forEach((k, v) -> sb.append(String.format("%s=%s;", k, v)));
      res = sb.toString();
    } else {
      res = String.format("%s=%s", key, startupEnv.getEnv().get(key));
    }

    return new ResponseEntity<>(
        res,
        HttpStatus.OK);
  }

  @GetMapping(value = "env", produces = "application/json")
  ResponseEntity<Map<String, String>> getEnv(@RequestParam(value = "key", defaultValue = "") String key) {
    log.debug("get startup env \"{}\" as json", key);

    Map<String, String> res;
    if (key.isBlank()) {
      res = startupEnv.getEnv();
    } else {
      res = Map.of(key, startupEnv.getEnv().get(key));
    }

    return new ResponseEntity<>(
        res,
        HttpStatus.OK);
  }

  @PostMapping("/echo")
  ResponseEntity<EchoResponse> echo(@RequestHeader Map<String, String> headers,
      @RequestBody String body) {
    log.debug("post echo request");
    headers.forEach((k, v) -> log.debug("{}={}", k, v));

    return new ResponseEntity<>(EchoResponse.builder()
        .headers(headers)
        .body(body)
        .build(),
        HttpStatus.OK);
  }

  @GetMapping("/tables")
  ResponseEntity<List<String>> listTables() {
    log.debug("list dynamodb tables");

    return new ResponseEntity<>(dynamoDbClient.listTables().tableNames(),
        HttpStatus.OK);
  }
}
