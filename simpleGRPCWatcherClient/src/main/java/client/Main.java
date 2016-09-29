package client;

import net.sourceforge.argparse4j.ArgumentParsers;
import net.sourceforge.argparse4j.inf.ArgumentParser;
import net.sourceforge.argparse4j.inf.ArgumentParserException;
import net.sourceforge.argparse4j.inf.Namespace;

public class Main {
	public static void main(String[] args) throws Exception {
		String url = "localhost:50052";
		ArgumentParser parser = ArgumentParsers.newArgumentParser("Main").defaultHelp(true)
				.description("A simple grpc client.");
		parser.addArgument("--url").type(String.class).help("Target Server url").setDefault(url);
		
		try {
			Namespace ns;
			ns = parser.parseArgs(args);
			url = ns.<String>get("url");
		} catch (ArgumentParserException e) {
			parser.handleError(e);
			System.exit(1);
		}

		try {
			SyncWatcherClient client = new SyncWatcherClient(url);
			client.watch();
		} catch (Exception e) {
			System.err.println("Fatal Error : ");
			e.printStackTrace();
			System.exit(1);
		}
	}
}
