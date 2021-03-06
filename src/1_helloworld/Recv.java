import com.rabbitmq.client.*;
import java.io.IOException;
import java.lang.*;

public class Recv {

  private final static String QUEUE_NAME = "hello";

  public static void main(String[] argv) throws Exception {
    ConnectionFactory factory = new ConnectionFactory();
    factory.setHost("rabbitmq-server");
    Connection connection = factory.newConnection();
    final Channel channel = connection.createChannel();

    channel.queueDeclare(QUEUE_NAME, false, false, false, null);
    System.out.println(" [*] Waiting for messages. To exit press CTRL+C");

    Consumer consumer = new DefaultConsumer(channel) {
      @Override
      public void handleDelivery(String consumerTag, Envelope envelope, AMQP.BasicProperties properties, byte[] body)
          throws IOException {
        long deliveryTag = envelope.getDeliveryTag();
        String message = new String(body, "UTF-8");
        System.out.println(" [x] Received '" + message + "', deliveryTag:'" + deliveryTag + "'");
      }
    };
    channel.basicConsume(QUEUE_NAME, true, consumer);
  }
}
