# GoConductor

GoConductor is a flexible, decentralized workflow orchestration framework built for microservices. It supports the Saga pattern, event-driven architectures, and ensures high availability, providing pluggable message queue options like Kafka and Kinesis. With GoConductor, developers can ensure that multi-stage processes in distributed systems either complete successfully or are properly rolled back.

## Problem We Are Solving

In distributed microservices architectures, managing long-running, multi-step processes can be challenging. Services can fail halfway through a process, leaving systems in inconsistent states. The **Saga pattern** solves this by ensuring that if one step in a process fails, compensating actions can be triggered to rollback the previous steps. However, existing workflow orchestration solutions often lack flexibility or require a centralized coordinator, which introduces a single point of failure.

**GoConductor** solves this problem by providing a **decentralized orchestration framework** where each microservice manages its own part of the workflow. This approach increases resilience and scalability, and allows users to define custom compensating actions. GoConductor ensures the entire workflow either completes successfully or is consistently rolled back.

## Key Features

- **Decentralized Workflow Coordination**: Each microservice manages its own steps, reducing the single point of failure in distributed workflows.
- **Saga Pattern Support**: Ensures transactional integrity with compensating actions for rolling back processes when failures occur.
- **Pluggable Message Queue**: Easily switch between Kafka, Kinesis, or future message queues for inter-service communication.
- **High Availability**: Configurable leader election (PostgreSQL, etcd, or Zookeeper) ensures fault tolerance and resilience.
- **Detailed State Tracking**: Track each workflow’s state (e.g., queued, in progress, rolling back, error) with granular status updates.
- **Flexible Compensation**: Microservices define their own compensating actions, but the architecture supports centralized enforcement for simpler workflows.

## High-Level Architecture

The architecture of GoConductor is designed to handle workflows across distributed microservices while ensuring scalability and resilience.

### Components:

1. **Decentralized Coordinator**:

   - Each microservice coordinates its own workflow steps and communicates its progress back to the system. This avoids a single point of failure.

2. **Message Queue (Kafka/Kinesis)**:

   - A pluggable interface supports Kafka, Kinesis, and future message queues, providing at-least-once message delivery. Deduplication is handled via unique idempotency keys.

3. **State Store (PostgreSQL)**:

   - PostgreSQL is used to store the state of every workflow, ensuring progress can be tracked and workflows can recover from failures. It also handles distributed locks for concurrency control.

4. **Leader Election**:

   - A configurable leader election mechanism allows users to choose between PostgreSQL advisory locks, etcd, or Zookeeper to ensure high availability.

5. **Workflow API (gRPC/REST)**:

   - Workflows are defined via a graph-based API with support for parallel execution, conditional branching, and compensating transactions. Both gRPC and REST interfaces are supported.

6. **Microservice-Defined Compensation**:
   - Each microservice can define its own compensating actions, ensuring flexibility for advanced use cases. Centralized enforcement is planned for future releases.

## Getting Started

### Prerequisites

- Go 1.18+
- PostgreSQL 13+
- Kafka or Kinesis (Optional: etcd, Zookeeper)
- gRPC and REST clients (for API interaction)

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/your-username/GoConductor.git
   cd GoConductor
   ```

2. Install dependencies:

   ```bash
   go mod tidy
   ```

3. Set up PostgreSQL:

   - Configure your PostgreSQL instance and update the connection details in your configuration.

4. Set up Kafka/Kinesis:
   - Choose your message queue and configure it in the system settings via the API (support for YAML coming soon).

### Running GoConductor

1. Start the GoConductor server:

   ```bash
   go run main.go
   ```

2. Access the API to define workflows and monitor progress via gRPC or REST.

## Configuration

GoConductor provides an API-based configuration system to set up your environment. Users can configure:

- **Leader Election Mechanism**: PostgreSQL, etcd, or Zookeeper.
- **Message Queue**: Kafka or Kinesis.
- **Database Credentials**: Secure storage for secrets and credentials.
- **Workflow Definitions**: Define complex workflows, compensating actions, and parallel execution steps.

YAML support for configuration will be added in future releases.

## Example

Here’s a quick example of how to define a simple workflow:

```go
// Define a workflow step
step1 := WorkflowStep{
    Name: "Process Payment",
    Execute: func() error {
        // Logic to process payment
        return nil
    },
    Compensate: func() error {
        // Logic to rollback payment if needed
        return nil
    },
}

// Define another step
step2 := WorkflowStep{
    Name: "Update Inventory",
    Execute: func() error {
        // Logic to update inventory
        return nil
    },
    Compensate: func() error {
        // Logic to rollback inventory update
        return nil
    },
}

// Define the workflow
workflow := Workflow{
    Name: "Order Processing",
    Steps: []WorkflowStep{step1, step2},
}

// Start the workflow
StartWorkflow(workflow)
```

## Roadmap

- Initial decentralized architecture
- Support for Kafka and Kinesis
- Add YAML configuration support
- Centralized compensation enforcement for simpler workflows
- Support for additional message queues (RabbitMQ, NATS)
- UI for workflow monitoring and management

## Contributing

Contributions are welcome! Please submit a pull request or open an issue to discuss any changes.

## License

This project is licensed under the Apache License 2.0. See the [LICENSE](LICENSE) file for details.
