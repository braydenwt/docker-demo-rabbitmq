import java.io.IOException;
import com.rabbitmq.client.ConnectionFactory;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.Channel;
import com.rabbitmq.client.MessageProperties;

public class NewTask {

  private static final String TASK_QUEUE_NAME = "task_queue";

  public static void main(String[] argv)
                      throws Exception {

    ConnectionFactory factory = new ConnectionFactory();
    factory.setHost("rabbitmq-server");
    Connection connection = factory.newConnection();
    Channel channel = connection.createChannel();

    channel.queueDeclare(TASK_QUEUE_NAME, true, false, false, null);

    int count = 0;
    while( true ) {
      String message = getMessage(count);
      channel.basicPublish( "", TASK_QUEUE_NAME,
              MessageProperties.PERSISTENT_TEXT_PLAIN,
              message.getBytes());
      System.out.println(" [x] Sent '" + message + "'");
      count++;
      Thread.sleep(700);
    }

    // channel.close();
    // connection.close();
  }

  private static String getMessage(int count){
    int n = count % 7;
    return new String(new char[n+1]).replace("\0", ".");
  }

}