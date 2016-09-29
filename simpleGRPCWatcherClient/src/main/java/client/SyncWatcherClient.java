package client;

import java.util.Iterator;
import java.util.concurrent.TimeUnit;

import io.grpc.ManagedChannel;
import io.grpc.netty.NegotiationType;
import io.grpc.netty.NettyChannelBuilder;
import test.DbEvent;
import test.DbWatchRequest;
import test.DbWatcherServiceGrpc;
import test.DbWatcherServiceGrpc.DbWatcherServiceBlockingStub;

public class SyncWatcherClient {
	private final String url;
	private final DbWatcherServiceBlockingStub stub;

	public SyncWatcherClient(String url) {
		this.url = url;
		stub = DbWatcherServiceGrpc.newBlockingStub(
				NettyChannelBuilder.forTarget(url).negotiationType(NegotiationType.PLAINTEXT).build());
	}

	public void watch() {
		System.out.println(String.format("Trying to watch %s", url));
		DbWatchRequest request = DbWatchRequest.getDefaultInstance();

		Iterator<DbEvent> iterator = stub.watch(request);
		while (iterator.hasNext()) {
			DbEvent response = iterator.next();
			System.out.println(String.format("Recieved %s notification : %s",response.getAction(), response.getPerson()));
		}
	}

	public void shutdown() {
		if (stub != null) {
			try {
				((ManagedChannel) stub.getChannel()).shutdown().awaitTermination(5, TimeUnit.SECONDS);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
	}
}
