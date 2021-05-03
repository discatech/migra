grant delete on table any_table to postgres;

DO
$$
    BEGIN
        IF (SELECT 1
            FROM information_schema.tables
            WHERE table_schema = 'public'
              AND table_name = 'products'
        ) THEN
            REVOKE select on table "public"."any_table" from "postgres";
        END IF;
    END
$$;
