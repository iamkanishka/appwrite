# Changelog for Apwrite v0.1.13

# Appwrite

Appwrite is an open-source self-hosted backend server that abstract and simplify complex and repetitive development tasks behind a very simple REST API


## v0.1.2 — 2024-11-14

## Feature(Helper Modules)

## Query Module
The Query module is a helper designed to construct query strings for filtering, sorting, and manipulating data when working with an Appwrite database. Here's an explanation of its components and how it works:


[Dynamic_Query_Building] -  The module uses a general-purpose new/3 function to construct a query with:

A method: Specifies the type of query (e.g., "equal", "lessThan").
An attribute: The field/attribute in the database being filtered or sorted.
A values: The value(s) to compare or filter against.
Encapsulation of Query Logic: It provides user-friendly functions like equal/2, greater_than/2, or contains/2 that internally call new/3 and return the appropriate JSON string.

[Support_for_Logical_Operations]:

Combines multiple queries using logical OR (logical_or) and AND (logical_and).
These functions decode individual query strings back to maps for nesting.
Filtering Capabilities: Offers a range of filtering methods, including:

Equality checks (equal/2, not_equal/2)
Range checks (less_than/2, between/3)
Null checks (is_null/1, is_not_null/1)
String pattern matching (starts_with/2, contains/2)
Sorting and Pagination:

[Supports_sorting_by_attributes] (order_asc/1, order_desc/1).
Enables pagination with limit/1, offset/1, and cursor-based navigation (cursor_after/1, cursor_before/1).
Custom Attributes Selection:

Use select/1 to specify which fields should be returned.



## v0.0.2 — 2024-11-14

## Feature(Helper Modules)

## ID Module

Helper module to generate ID strings for resources. This module provides functions
to generate unique ID strings, either based on a timestamp or with custom or Appwrite-like generation methods.

hex_timestamp/0:

Generates a hexadecimal timestamp based on the current time in seconds and milliseconds (equivalent to #hexTimestamp in TypeScript).
Uses :os.system_time(:seconds) for the timestamp and :os.system_time(:milli_seconds) for milliseconds.
custom/1:

Takes a string and returns it as is (similar to the TypeScript custom method).
unique/1:

Generates a unique ID by concatenating the hexadecimal timestamp with random padding (default of 7 digits, configurable).
Uses :rand.uniform/1 to generate random digits and append them to the base ID.

## Permission Module

Helper module for generating permission strings for resources.

Each function (read, write, create, update, delete) generates a permission string by embedding the given role in a specific permission format.
The @doc annotations provide descriptions and usage examples, making the module easy to understand and use.
Each function guards with when is_binary(role) to ensure the role is a string.

## Role Module

Helper module for generating role strings for `Permission`.

The functions any/0, user/2, users/1, guests/0, team/2, member/1, and label/1 provide specific role strings, with optional parameters where needed.
Each function is documented with @doc annotations that describe its purpose, parameters, and usage examples.

## v0.1.2 — 2024-11-14

## Feature(Types Modules)

### Algo Types:

[AlgoMd5] - Represents the MD5 hashing algorithm configuration.
[AlgoSha] - Represents the SHA hashing algorithm configuration.
[AlgoPhpass] - Configuration for the PHPass password hashing algorithm.
[AlgoBcrypt] - Configuration for the Bcrypt password hashing algorithm.
[AlgoScrypt] - Scrypt hashing algorithm with parameters for CPU, memory, and parallelization costs.
[AlgoScryptModified] - Modified Scrypt with additional salt and key-signing configurations.
[AlgoArgon2] - Argon2 hashing algorithm with memory, time, and thread cost parameters.

### Country and Locale:

[Country] - Represents a country with its name and ISO 3166-1 alpha code.
[Continent] - Represents a continent with its name and two-letter code.
[Language] - Represents a language with its name, code, and native name.
[Currency] - Represents currency details such as name, symbol, and ISO 4217 code.
[Phone] - Represents a phone code along with associated country details.

### MFA and Authentication:

[MfaChallenge] - Represents an MFA challenge token with expiration details.
[MfaRecoveryCodes] - Contains a list of recovery codes for MFA.
[MfaType] - Defines the secret token and URI for TOTP MFA setup.
[MfaFactors] - Flags indicating supported MFA factors (e.g., TOTP, SMS, email).

### Subscribers and Targets:

[Subscriber] - Defines a subscriber to a topic, including user and provider details.
[Target] - Represents a target, such as an email or phone, with associated provider details.

### Teams and Memberships:

Team<Preferences>: Represents a team with its details and customizable preferences.
Membership: Represents a user's membership in a team, including roles and statuses.

### Executions and Logs:

[Execution] - Represents a function execution, including logs, errors, and duration.
[ExecutionList] - A list of executions with total count and execution details.
[LogList] - A list of logs with total count and log details.

### User Models:

User<Preferences>: Represents a user, including their preferences, targets, and verification status.
Document Collections:

DocumentList<Document>: A collection of documents with total count and individual entries.

### Lists:

[SessionList] - A list of sessions, including total count and details.
[IdentityList] - A list of user identities with total count and details.
[FileList] - A list of files, including total count and metadata.
[MembershipList] - A list of memberships, including total count and individual details.
[CountryList] - A list of countries, including total count and details.
[ContinentList] - A list of continents, including total count and details.
[LanguageList] - A list of languages, including total count and details.
[CurrencyList] - A list of currencies, including total count and metadata.
[PhoneList] - A list of phone codes and associated country details.
[LocaleCodeList] - A list of locale codes with their total count and individual entries.

## v0.1.1 — 2024-11-13

## Feature(Const with validation)

[Consts] modules to for the following resources

[AuthenticationFactor] - Defines supported authentication factors such as email, phone, and TOTP.
[AuthenticatorType] Specifies the available authenticator types (currently just TOTP).
[Browser] - Lists various browser types with associated shorthand values.
[CreditCard] - Covers a wide range of credit card types such as American Express, Visa, MasterCard, etc.
[ExecutionMethod] - Includes HTTP methods like GET, POST, PUT, DELETE, etc.
[Flag]: Represents various country flags using two-letter country codes.
[ImageFormat]: Lists common image formats such as JPG, PNG, and WebP.
[ImageGravity]: Defines different image positioning values (e.g., center, top-left, bottom-right).
[OAuthProvider]: Covers a wide list of OAuth providers like Google, GitHub, PayPal, and many others.



