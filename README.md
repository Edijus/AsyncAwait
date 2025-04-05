# AsyncAwait
Async Thread Function Executor with Exception Handling
This Delphi unit implements a generic asynchronous execution framework that runs functions in background threads and safely delivers the result (or any exception) to a callback on the main thread. It’s designed to simplify asynchronous processing in Delphi applications while providing robust exception handling.
Overview
The core component of this unit is the TAsync<T> class that implements the IAsync<T> interface. It allows you to:

Execute a function asynchronously using a background thread.

Return a result of any type (T) or an exception if one occurs during execution.

Use a callback procedure (TAwaitProc<T>) to handle the result or exception on the main thread.

Additionally, you can integrate this unit with an OperationToken mechanism (from our other repository) for enhanced cancellation support during asynchronous operations.

Features
Generic Asynchronous Execution:
Execute any function asynchronously and handle its result or any exception in a type-safe manner.

Exception Handling:
Captures exceptions thrown during asynchronous execution and passes them to the callback for graceful error handling.

Main Thread Synchronization:
Uses TThread.Queue to ensure that the callback is executed on the main thread, making it safe for UI updates.

Easy Integration:
The helper class TAsyncHelper provides a simple API to run asynchronous functions with minimal boilerplate code.

Cancellation Support:
Although not built-in, the unit can be enhanced by integrating with the OperationToken library from my other repository, allowing you to cancel long-running operations gracefully.

