import com.rabbitmq.client.*;

import java.io.IOException;
import java.lang.*;
import java.util.*;
import java.util.concurrent.*;

public class Worker {
  private static final String TASK_QUEUE_NAME = "task_queue";

  public static void main(String[] argv) throws Exception {
    ConnectionFactory factory = new ConnectionFactory();
    factory.setHost("rabbitmq-server");
    factory.setRequestedHeartbeat(30);
    factory.setAutomaticRecoveryEnabled(true);

    int threadNumber = 10;
    final ExecutorService threadPool =  new ThreadPoolExecutor(threadNumber, threadNumber,
                0L, TimeUnit.MILLISECONDS,
                new LinkedBlockingQueue<Runnable>());

    final Connection connection = factory.newConnection();
    connection.addShutdownListener(new ShutdownListener() {
        // this will be triggered multiple times
        public void shutdownCompleted(ShutdownSignalException cause)
        {
          // true if this signals a connection error, or false if a channel error
          if (cause.isHardError())
          {
            System.out.println(" Shutdown initiated by " + (cause.isInitiatedByApplication() ? "Application" : "Server"));
          }
          else {
            System.out.println(" Shutdown caused by channel error.");
          }
        }
    });

    final Channel channel = connection.createChannel();
    channel.queueDeclare(TASK_QUEUE_NAME, true, false, false, null);
    channel.basicQos(20);

    // System.out.println("Heartbeat Interval:" + Integer.toString(factory.getRequestedHeartbeat()));
    System.out.println(" [*] Waiting for messages. To exit press CTRL+C");

    final Consumer consumer = new DefaultConsumer(channel) {
      @Override
      public void handleDelivery(String consumerTag, Envelope envelope, AMQP.BasicProperties properties, byte[] body) throws IOException {
        final String message = new String(body, "UTF-8");
        System.out.println(" [x] Received '" + message + "'" );
        final long deliveryTag = envelope.getDeliveryTag();
// solution_1
        // try {
        //   doWork(message);
        //   channel.basicAck(deliveryTag, false);
        // } finally {
        //   System.out.println(" [x] Done.");
        // }
// solution_2
        threadPool.submit(new Runnable() {
          public void run() {
            try {
              doWork(message);
              channel.basicAck(deliveryTag, false);
            } catch (IOException ex) {
              // TODO
            } finally {
              System.out.println(" [x] Done.");
            }
          }
        });
      }

      // this will be triggered only once
      @Override
      public void handleShutdownSignal(java.lang.String consumerTag, ShutdownSignalException sig) {
        System.out.println(" Consumer shutdown");
      }
    };

    channel.basicConsume(TASK_QUEUE_NAME, false, consumer);
  }

  private static void doWork(String task) {
    for (char ch : task.toCharArray()) {
      if (ch == '.') {
        try {
          Thread.sleep(1000);
        } catch (InterruptedException _ignored) {
          Thread.currentThread().interrupt();
        }
      }
    }
  }

  private static void assignCurrentThreadName() {
    String name = UUID.randomUUID().toString();
    Thread.currentThread().setName(name);
  }

  private static String getCurrentThreadName() {
    return Thread.currentThread().getName();
  }

  private static Integer getCurrentThreadCount() {
    return Thread.activeCount();
  }
}